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

console.log("Preparing script to build comprehensive Word Document (.docx)...");
