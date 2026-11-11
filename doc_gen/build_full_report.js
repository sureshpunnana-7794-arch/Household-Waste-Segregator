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
const ARTIFACT_DOCX = "C:/Users/Suresh/.gemini/antigravity/brain/df9675a4-04c3-472d-8438-6970f311a23e/ECOSORT_PROJECT_REPORT_SDG.docx";

console.log("Compiling Academic Project Report Word Document...");

// Color Palette Constants
const COLOR_PRIMARY = "1B5E20";   // Deep Forest Green
const COLOR_SECONDARY = "2E7D32"; // Medium Emerald Green
const COLOR_ACCENT = "388E3C";    // Light Accent Green
const COLOR_DARK = "1F2937";      // Body Text Dark Slate
const COLOR_MUTED = "4B5563";     // Muted Gray
const COLOR_BG_LIGHT = "F4FBF7";  // Very Soft Green Tint
const COLOR_BORDER = "CBD5E1";    // Soft Slate Border

const borderThin = { style: BorderStyle.SINGLE, size: 4, color: COLOR_BORDER };
const bordersCell = { top: borderThin, bottom: borderThin, left: borderThin, right: borderThin };

function h1(text) {
  return new Paragraph({
    text: text,
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 360, after: 180 },
    keepNext: true,
  });
}

function h2(text) {
  return new Paragraph({
    text: text,
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 260, after: 120 },
    keepNext: true,
  });
}

function h3(text) {
  return new Paragraph({
    text: text,
    heading: HeadingLevel.HEADING_3,
    spacing: { before: 180, after: 80 },
    keepNext: true,
  });
}

function p(text, opts = {}) {
  return new Paragraph({
    children: [
      new TextRun({
        text: text,
        size: opts.size || 22, // 11pt
        color: opts.color || COLOR_DARK,
        bold: opts.bold || false,
        italics: opts.italics || false,
      }),
    ],
    alignment: opts.alignment || AlignmentType.LEFT,
    spacing: { before: opts.before || 60, after: opts.after || 100, line: 280 },
  });
}

function bullet(boldPrefix, text) {
  return new Paragraph({
    children: [
      new TextRun({ text: boldPrefix + " ", bold: true, size: 22, color: COLOR_PRIMARY }),
      new TextRun({ text: text, size: 22, color: COLOR_DARK }),
    ],
    bullet: { level: 0 },
    spacing: { before: 40, after: 60, line: 260 },
  });
}

function callout(title, body) {
  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [
      new TableRow({
        children: [
          new TableCell({
            borders: {
              top: { style: BorderStyle.NONE },
              bottom: { style: BorderStyle.NONE },
              right: { style: BorderStyle.NONE },
              left: { style: BorderStyle.SINGLE, size: 24, color: COLOR_PRIMARY },
            },
            shading: { fill: COLOR_BG_LIGHT, type: ShadingType.CLEAR, color: "auto" },
            margins: { top: 140, bottom: 140, left: 180, right: 180 },
            children: [
              new Paragraph({
                children: [
                  new TextRun({ text: title, bold: true, color: COLOR_PRIMARY, size: 22 }),
                ],
                spacing: { after: 60 },
              }),
              new Paragraph({
                children: [
                  new TextRun({ text: body, color: COLOR_DARK, size: 21, italics: true }),
                ],
                spacing: { line: 260 },
              }),
            ],
          }),
        ],
      }),
    ],
  });
}

function createTable(headers, rows, colWidthPercentages) {
  const headerRow = new TableRow({
    tableHeader: true,
    children: headers.map((h, i) => new TableCell({
      width: { size: colWidthPercentages[i], type: WidthType.PERCENTAGE },
      borders: bordersCell,
      shading: { fill: COLOR_PRIMARY, type: ShadingType.CLEAR, color: "auto" },
      margins: { top: 120, bottom: 120, left: 120, right: 120 },
      children: [
        new Paragraph({
          children: [new TextRun({ text: h, bold: true, color: "FFFFFF", size: 20 })],
          alignment: AlignmentType.CENTER,
        }),
      ],
    })),
  });

  const bodyRows = rows.map((r, rowIdx) => new TableRow({
    children: r.map((cellText, cIdx) => new TableCell({
      width: { size: colWidthPercentages[cIdx], type: WidthType.PERCENTAGE },
      borders: bordersCell,
      shading: {
        fill: rowIdx % 2 === 0 ? "FFFFFF" : COLOR_BG_LIGHT,
        type: ShadingType.CLEAR,
        color: "auto",
      },
      margins: { top: 100, bottom: 100, left: 120, right: 120 },
      children: [
        new Paragraph({
          children: [
            new TextRun({
              text: cellText,
              size: 20,
              color: COLOR_DARK,
              bold: cIdx === 0 && r.length > 2,
            }),
          ],
          alignment: cIdx === 0 || cIdx === 1 ? AlignmentType.LEFT : AlignmentType.CENTER,
          spacing: { line: 240 },
        }),
      ],
    })),
  }));

  return new Table({
    width: { size: 100, type: WidthType.PERCENTAGE },
    rows: [headerRow, ...bodyRows],
  });
}

function imageFigure(imgFilename, figNumber, captionTitle, description) {
  const fullPath = path.join(SCREENSHOTS_DIR, imgFilename);
  if (!fs.existsSync(fullPath)) {
    console.warn("Screenshot not found: " + fullPath);
    return [p("[Image missing: " + imgFilename + "]")];
  }
  const imgBuffer = fs.readFileSync(fullPath);

  return [
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 180, after: 80 },
      keepNext: true,
      children: [
        new ImageRun({
          data: imgBuffer,
          transformation: {
            width: 250,
            height: 520,
          },
        }),
      ],
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 60, after: 60 },
      keepNext: true,
      children: [
        new TextRun({ text: `Figure ${figNumber}: `, bold: true, color: COLOR_PRIMARY, size: 20 }),
        new TextRun({ text: captionTitle, bold: true, color: COLOR_DARK, size: 20 }),
      ],
    }),
    new Paragraph({
      alignment: AlignmentType.CENTER,
      spacing: { before: 0, after: 180 },
      children: [
        new TextRun({ text: description, italics: true, color: COLOR_MUTED, size: 19 }),
      ],
    }),
  ];
}

console.log("Building document content sections...");
