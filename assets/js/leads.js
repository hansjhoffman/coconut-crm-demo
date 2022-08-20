import { Flatfile } from "@flatfile/sdk";

const EMBED_ID = "";

export const importLeads = (csrfToken) => {
  Flatfile.requestDataFromUser({
    embedId: EMBED_ID,
    token: async () => {
      const response = await fetch("/auth/flatfile", {
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
    onInit: ({ meta }) => {
      console.log(
        `%c⥤ Batch ${meta.batchId} has been initialized.`,
        "background-color: #4a3fd2; padding: 4px;",
      );
    },
    onData: (chunk, next) => {
      chunk.records.forEach(console.log);
      next();
    },
    onComplete: () => {
      console.log("thank you for importing");
    },
    onError: ({ error }) => {
      console.error(`%c⥤ ${error.userMessage}`, "color: red; padding: 4px;");
    },
  });
};
