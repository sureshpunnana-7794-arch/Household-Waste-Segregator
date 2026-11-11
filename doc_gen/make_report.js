const {
  Document,
  Packer,
  Paragraph,
  TextRun,
  HeadingLevel,
  Table,
  TableRow,
  TableCell,
  WidthType,
  AlignmentType,
  BorderStyle,
  ImageRun,
  Header,
  Footer,
  PageNumber,
  NumberFormat,
  ShadingType,
} = require("docx");
const fs = require("fs");
const path = require("path");

const SCREENSHOTS_DIR = "c:/Users/Suresh/Desktop/FSD PROJECT/Household-Waste-Segregator/docs/screenshots";
const OUTPUT_DOCX = "c:/Users/Suresh/Desktop/FSD PROJECT/Household-Waste-Segregator/ECOSORT_PROJECT_REPORT_SDG.docx";
const OUTPUT_HTML = "c:/Users/Suresh/Desktop/FSD PROJECT/Household-Waste-Segregator/ECOSORT_PROJECT_REPORT_SDG.html";
const OUTPUT_PDF = "c:/Users/Suresh/Desktop/FSD PROJECT/Household-Waste-Segregator/ECOSORT_PROJECT_REPORT_SDG.pdf";

console.log("Starting generation of comprehensive SDG Project Report...");
