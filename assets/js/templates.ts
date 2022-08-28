import * as FF from "@flatfile/configure";
// import { FlatfileRecord } from "@flatfile/hooks";

/*
 * Field Validations
 */

const ensureValidEmail = (value: string): Array<FF.Message> => {
  return value.includes("@") ? [] : [new FF.Message("Invalid email address.", "error", "validate")];
};

const ensureValidUrlSchema = (value: string): Array<FF.Message> => {
  const re = /^https?:\/\//g;

  return re.test(value) ? [] : [new FF.Message("Invalid url schema", "warn", "validate")];
};

/*
 * Record Hooks
 */

// may not need this b/c we'll be doing valid email check on BE
// const emailOrPhoneRequired = (record: FlatfileRecord) => {
//   const email = record.get("email");
//   const phone = record.get("phone");

//   if (G.isNil(email) && G.isNil(phone)) {
//     record.addWarning(
//       ["email", "phone"],
//       "Must have either phone or email.",
//     );
//   }

//   return record;
// };

const Leads = new FF.Sheet(
  "Leads (Coconut)",
  {
    first_name: FF.TextField({
      label: "First Name",
    }),
    last_name: FF.TextField({
      label: "Last Name",
    }),
    email: FF.TextField({
      label: "Email Address",
      required: true,
      unique: true,
      compute: (value) => {
        return value.trim().toLowerCase();
      },
      validate: (value) => {
        const isValidEmail = ensureValidEmail(value);

        return [...isValidEmail];
      },
    }),
    phone: FF.TextField({
      label: "Phone Number",
    }),
    date: FF.DateField({
      label: "Date",
    }),
    country: FF.TextField({
      label: "Country",
      compute: (value) => {
        return value;
      },
    }),
    postal_code: FF.TextField({
      label: "Postal Code",
    }),
    opt_in: FF.BooleanField({
      label: "Opt In",
    }),
    deal_status: FF.OptionField({
      label: "Deal Status",
      options: {
        prospecting: "Prospecting",
        discovery: "Discovery",
        proposal: "Proposal",
        negotiation: "Negotiation",
        closed_won: "Closed Won",
        closed_lost: "Closed Lost",
      },
    }),
  },
  {
    allowCustomFields: true,
    readOnly: true,
    recordCompute: (_record, _logger) => {},
    batchRecordsCompute: async (_payload) => {},
  },
);

const Products = new FF.Sheet(
  "Products (Coconut)",
  {
    // do I need this?
    sku: FF.TextField({
      label: "SKU",
      required: true,
      unique: true,
      primary: true,
    }),
    displayName: FF.TextField({
      label: "Product Name",
    }),
    // https://support.ecwid.com/hc/en-us/articles/360011125640-Understanding-SKU-Formats#understanding-sku-formats
    // might not need this
    size: FF.OptionField({
      label: "Size",
      options: {
        xs: "XS",
      },
    }),
    available_after: FF.DateField({
      label: "Available After",
    }),
    available_before: FF.DateField({
      label: "Available Before",
    }),
    feature: FF.BooleanField({
      label: "Featured?",
    }),
    image: FF.TextField({
      label: "Image URL",
      compute: (value) => {
        return value.trim().toLowerCase();
      },
      validate: (value) => {
        const isValidUrlSchema = ensureValidUrlSchema(value);

        return [...isValidUrlSchema];
      },
    }),
    currency: FF.OptionField({
      label: "Currency",
      options: {
        cad: "CAD",
        usd: "USD",
      },
    }),
    price: FF.NumberField({
      label: "Price",
      compute: (value) => {
        return Number.parseFloat(value.toFixed(2));
      },
    }),
  },
  {
    allowCustomFields: true,
    readOnly: true,
    recordCompute: (_record, _logger) => {},
    batchRecordsCompute: async (_payload) => {},
  },
);

const Workbook = new FF.Workbook({
  name: "Coconut (Demo)",
  namespace: "Coconut",
  sheets: {
    Leads,
    Products,
  },
});

export default Workbook;
