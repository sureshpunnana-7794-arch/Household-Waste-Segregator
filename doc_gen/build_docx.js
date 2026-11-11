const {
  Document,
  Packer,
  Paragraph,
  TextRun,
  Header,
  Footer,
  PageNumber,
  NumberFormat,
  AlignmentType,
} = require("docx");
const fs = require("fs");
const path = require("path");

const { getTitlePageElements } = require("./sections/title_page");
const { getSdgChapterElements } = require("./sections/sdg_chapter");
const { getTechnicalChaptersElements } = require("./sections/technical_chapters");
const { getScreenshotsChapterElements } = require("./sections/screenshots_chapter");
const { getTestingAppendicesElements } = require("./sections/testing_appendices");
const { COLOR_PRIMARY, COLOR_MUTED } = require("./helpers");

const OUTPUT_DOCX = "c:/Users/Suresh/Desktop/FSD PROJECT/Household-Waste-Segregator/ECOSORT_PROJECT_REPORT_SDG.docx";
const ARTIFACT_DOCX = "C:/Users/Suresh/.gemini/antigravity/brain/df9675a4-04c3-472d-8438-6970f311a23e/ECOSORT_PROJECT_REPORT_SDG.docx";

async function generateDocx() {
  console.log("Assembling comprehensive Word Document sections...");

  const allChildren = [
    ...getTitlePageElements(),
    ...getTechnicalChaptersElements().slice(0, 7), // Intro, Problem, Objectives
    ...getSdgChapterElements(), // Deep UN SDG Alignment Chapter
    ...getTechnicalChaptersElements().slice(7), // Requirements, Architecture, AI, Code
    ...getScreenshotsChapterElements(), // All 6 Embedded Screenshots with analysis
    ...getTestingAppendicesElements(), // Test cases, Build guide, 25 Viva Q&A, Rubric Checklist
  ];

  const doc = new Document({
    creator: "P. Suresh (24PA1A05I3)",
    title: "EcoSort: Smart Household Waste Segregator - SDG Project Report",
    description: "Flutter SDG Laboratory Mini-Project Report for Vishnu Institute of Technology, Bhimavaram",
    styles: {
      default: {
        document: {
          run: {
            font: "Segoe UI",
            size: 22, // 11pt
            color: "1F2937",
          },
        },
      },
    },
    sections: [
      {
        properties: {
          page: {
            margin: {
              top: 1440,    // 1 inch
              bottom: 1440, // 1 inch
              left: 1440,   // 1 inch
              right: 1440,  // 1 inch
            },
          },
        },
        headers: {
          default: new Header({
            children: [
              new Paragraph({
                alignment: AlignmentType.RIGHT,
                children: [
                  new TextRun({
                    text: "EcoSort: Household Waste Segregator | P. Suresh (24PA1A05I3) | VIT-B",
                    size: 16,
                    color: COLOR_MUTED,
                    italics: true,
                  }),
                ],
              }),
            ],
          }),
        },
        footers: {
          default: new Footer({
            children: [
              new Paragraph({
                alignment: AlignmentType.RIGHT,
                children: [
                  new TextRun({
                    text: "Flutter SDG Project Record Book — Page ",
                    size: 16,
                    color: COLOR_MUTED,
                  }),
                  new TextRun({
                    children: [PageNumber.CURRENT],
                    size: 16,
                    bold: true,
                    color: COLOR_PRIMARY,
                  }),
                  new TextRun({
                    text: " of ",
                    size: 16,
                    color: COLOR_MUTED,
                  }),
                  new TextRun({
                    children: [PageNumber.TOTAL_PAGES],
                    size: 16,
                    color: COLOR_MUTED,
                  }),
                ],
              }),
            ],
          }),
        },
        children: allChildren,
      },
    ],
  });

  console.log("Packing Word Document buffer...");
  const buffer = await Packer.toBuffer(doc);

  fs.writeFileSync(OUTPUT_DOCX, buffer);
  console.log(`Successfully generated DOCX at: ${OUTPUT_DOCX} (${buffer.length} bytes)`);

  try {
    fs.writeFileSync(ARTIFACT_DOCX, buffer);
    console.log(`Copied DOCX to artifact directory: ${ARTIFACT_DOCX}`);
  } catch (err) {
    console.warn("Could not copy to artifact directory:", err.message);
  }
}

generateDocx().catch((err) => {
  console.error("Error generating DOCX:", err);
  process.exit(1);
});
