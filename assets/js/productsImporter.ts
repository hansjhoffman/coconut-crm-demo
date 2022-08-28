import { Flatfile } from "@flatfile/sdk";

import { prettyPrint } from "./utils";

const EMBED_ID: string = "bafedf6e-0133-4155-bcbe-e4d017aaf8ec";

export default (csrfToken: string) => {
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
      prettyPrint("info", `Batch ${meta.batchId} has been initialized.`);
    },
    onData: (chunk, next): void => {
      prettyPrint("info", `Chunk: ${chunk.records}.`);

      next();
    },
    onComplete: (): void => {
      prettyPrint("info", "Thank you for importing!");
    },
    onError: ({ error }): void => {
      prettyPrint("error", `${error.userMessage}`);
    },
  });
};
