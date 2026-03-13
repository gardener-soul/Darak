import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";
import { defineSecret, defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";

// 비용 제어: 최대 컨테이너 수 제한
setGlobalOptions({ maxInstances: 10, region: "asia-northeast3" });

// Secret Manager에서 Resend API Key 참조 (소스코드 노출 없음)
const resendApiKey = defineSecret("RESEND_API_KEY");

// ─── 파라미터 설정 (functions/.env 파일에서 값 주입, git 추적 제외) ────────
/** 알림을 수신할 관리자(개발자) 이메일 — functions/.env에서 ADMIN_EMAIL= 로 설정 */
const adminEmail = defineString("ADMIN_EMAIL");

/**
 * 발신자 이메일.
 * - Resend 커스텀 도메인 미설정 시: "onboarding@resend.dev" 그대로 사용
 *   (단, ADMIN_EMAIL이 Resend 계정 이메일과 동일해야 함)
 * - 커스텀 도메인 설정 시: "noreply@yourdomain.com" 형식으로 변경
 */
const FROM_EMAIL = "onboarding@resend.dev";

// ─── Cloud Function ──────────────────────────────────────────────────────

/**
 * Firestore `churches` 컬렉션에 새 문서가 생성될 때 관리자에게 이메일 알림을 발송합니다.
 * status == 'pending' 인 문서(신규 신청)에만 반응합니다.
 */
export const notifyChurchRegistration = onDocumentCreated(
  {
    document: "churches/{churchId}",
    secrets: [resendApiKey],
  },
  async (event) => {
    const data = event.data?.data();

    if (!data) {
      logger.warn("notifyChurchRegistration: 문서 데이터 없음, 스킵");
      return;
    }

    // 신규 신청(pending)만 처리 — 승인/거절 수정 이벤트 무시
    if (data.status !== "pending") {
      logger.info("notifyChurchRegistration: pending 아님, 스킵", {
        status: data.status,
      });
      return;
    }

    const {
      name,
      address,
      seniorPastor,
      denomination,
      requestMemo,
      requestedBy,
    } = data;

    const emailHtml = `
      <div style="font-family: sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #E8735A;">📋 새 교회 등록 신청</h2>
        <p>Darak 앱에서 새 교회 등록 신청이 접수되었습니다.</p>
        <table style="width: 100%; border-collapse: collapse; margin-top: 16px;">
          <tr style="background: #f9f9f9;">
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left; width: 140px;">교회 이름</th>
            <td style="padding: 10px; border: 1px solid #ddd;">${name ?? "-"}</td>
          </tr>
          <tr>
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">주소</th>
            <td style="padding: 10px; border: 1px solid #ddd;">${address ?? "-"}</td>
          </tr>
          <tr style="background: #f9f9f9;">
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">담임목사</th>
            <td style="padding: 10px; border: 1px solid #ddd;">${seniorPastor ?? "-"}</td>
          </tr>
          <tr>
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">교단</th>
            <td style="padding: 10px; border: 1px solid #ddd;">${denomination ?? "-"}</td>
          </tr>
          <tr style="background: #f9f9f9;">
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">신청 메모</th>
            <td style="padding: 10px; border: 1px solid #ddd;">${requestMemo ?? "-"}</td>
          </tr>
          <tr>
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">신청자 UID</th>
            <td style="padding: 10px; border: 1px solid #ddd; font-size: 12px; color: #888;">${requestedBy ?? "-"}</td>
          </tr>
        </table>
        <p style="margin-top: 24px; color: #888; font-size: 13px;">
          👉 <a href="https://console.firebase.google.com/project/darak-44719/firestore">Firebase 콘솔</a>에서
          해당 문서의 status를 <strong>approved</strong> 또는 <strong>rejected</strong>로 수정해 주세요.
        </p>
      </div>
    `;

    try {
      const response = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${resendApiKey.value()}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: FROM_EMAIL,
          to: [adminEmail.value()],
          subject: `[Darak] 교회 등록 신청 — ${name}`,
          html: emailHtml,
        }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        // 5xx 서버 오류: throw하여 Cloud Functions 자동 재시도 유도
        if (response.status >= 500) {
          throw new Error(
            `Resend 서버 오류 (재시도 대상): ${response.status} ${errorText}`,
          );
        }
        // 4xx 클라이언트 오류: 재시도해도 의미 없으므로 로깅만
        logger.error("Resend 이메일 발송 실패 (4xx)", {
          status: response.status,
          error: errorText,
        });
        return;
      }

      logger.info("교회 등록 알림 이메일 발송 완료", { churchName: name });
    } catch (error) {
      logger.error("이메일 발송 중 예외 발생", { error });
      throw error; // Cloud Functions 재시도 메커니즘 활용
    }
  },
);
