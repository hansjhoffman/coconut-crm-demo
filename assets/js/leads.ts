import { Flatfile } from "@flatfile/sdk";

const EMBED_ID: string = "e0c14de2-27d9-4477-b6b7-8605085b8039";

export const importLeads = (csrfToken: string) => {
  Flatfile.requestDataFromUser({
    embedId: EMBED_ID,
    token: async () => {
      const response = await fetch("/flatfile/auth", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({
          embedId: EMBED_ID,
        }),
      });
      const { token } = await response.json();

      return token;
    },
    theme: {
      displayName: "Display Name",
      hideConfetti: false,
      loadingText: "Custom loading text ...",
      logo: "URL_TO_YOUR_CUSTOM_LOGO",
      submitCompleteText: "Custom submit text ...",
    },
    onInit: ({ meta }): void => {
      console.log(
        `%c⥤ Batch ${meta.batchId} has been initialized.`,
        "background-color: #4a3fd2; padding: 4px;",
      );
    },
    onData: (chunk, next): void => {
      console.log(`%c⥤ Chunk: ${chunk.records}.`, "background-color: #4a3fd2; padding: 4px;");

      next();
    },
    onComplete: (): void => {
      console.log("thank you for importing");
    },
    onError: ({ error }): void => {
      console.error(`%c⥤ ${error.userMessage}`, "color: red; padding: 4px;");
    },
  });
};
