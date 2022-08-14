import { flatfileImporter } from "@flatfile/sdk";

const template = document.createElement("template");
template.innerHTML = `
  <slot id="ff-launcher" name="launcher" />
`;

class FlatfileImporter extends HTMLElement {
  static get observedAttributes() {
    return ["data-token"];
  }

  constructor() {
    super();

    this.token = null;

    this.attachShadow({ mode: "open" });
    this.shadowRoot.appendChild(template.content.cloneNode(true));
  }

  connectedCallback() {
    const launcherBtn = this.shadowRoot.querySelector("#ff-launcher");
    if (launcherBtn !== null) {
      launcherBtn.addEventListener("click", () => this.launch());
    }
  }

  attributeChangedCallback(attrName, oldVal, newVal) {
    if (newVal === oldVal) return;

    switch (attrName) {
      case "data-token":
        this.token = newVal;
        break;
      default:
        break;
    }
  }

  disconnectedCallback() {
    const launcherBtn = this.shadowRoot.querySelector("#ff-launcher");
    if (launcherBtn !== null) {
      launcherBtn.removeEventListener("click", () => this.launch());
    }
  }

  launch() {
    const importer = flatfileImporter(this.token);

    importer.on("init", ({ batchId }) => {
      console.log(
        "%c" + `⥤ Batch ${batchId} has been initialized.`,
        "background-color: #4a3fd2; padding: 4px;",
      );
    });

    importer.on("launch", ({ batchId }) => {
      console.log(
        "%c" + `⥤ Batch ${batchId} has been launched.`,
        "background-color: #4a3fd2; padding: 4px;",
      );
    });

    importer.on("error", (error) => {
      console.error("%c" + `⥤ ${error}`, "color: red; padding: 4px;");
    });

    importer.on("complete", async (payload) => {
      const data = await payload.data();
      const deserialized = JSON.stringify(data, null, 4);

      console.group("%c" + "⥤ SDK Output: 👇", "background-color: #4a3fd2; padding: 4px;");
      console.log("%c" + deserialized, "background-color: #4a3fd2; padding: 4px;");
    });

    importer.launch();
  }
}

customElements.define("flatfile-importer", FlatfileImporter);
