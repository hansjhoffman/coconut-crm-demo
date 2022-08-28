import { match } from "ts-pattern";

const css: string = "color: #000; background-color: #75ba1b; padding: 4px;";

export const prettyPrint = (level: "info" | "warn" | "error", msg: string) => {
  match(level)
    .with("info", () => console.log(`%c⥤ ${msg}`, css))
    .with("warn", () => console.warn(`%c⥤ ${msg}`, css))
    .with("error", () => console.error(`%c⥤ ${msg}`, css))
    .exhaustive();
};
