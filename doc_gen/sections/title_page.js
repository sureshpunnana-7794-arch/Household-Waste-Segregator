const { Paragraph, TextRun, AlignmentType } = require("docx");
const {
  h1,
  h2,
  p,
  bullet,
  callout,
  createTable,
  pageBreak,
  COLOR_PRIMARY,
  COLOR_SECONDARY,
  COLOR_MUTED,
  COLOR_DARK,
} = require("../helpers");

function getTitlePageElements() {
  const elements = [];

  // College Header
  elements.push(
    new Paragraph({
      children: [
        new TextRun({
          text: "VISHNU INSTITUTE OF TECHNOLOGY (AUTONOMOUS)",
          bold: true,
          size: 28,
          color: COLOR_PRIMARY,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { before: 100, after: 60 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "Approved by AICTE, Accredited by NBA & NAAC with 'A++' Grade | Affiliated to JNTUK",
          size: 18,
          color: COLOR_MUTED,
          italics: true,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { after: 40 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "Vishnupur, Bhimavaram - 534202, West Godavari District, Andhra Pradesh, India",
          size: 18,
          color: COLOR_MUTED,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { after: 200 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING",
          bold: true,
          size: 22,
          color: COLOR_SECONDARY,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { before: 80, after: 240 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "A FLUTTER SDG LABORATORY PROJECT REPORT ON",
          size: 19,
          bold: true,
          color: COLOR_MUTED,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { after: 120 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "ECOSORT: SMART HOUSEHOLD WASTE SEGREGATOR",
          bold: true,
          size: 34,
          color: COLOR_PRIMARY,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { before: 100, after: 100 },
    }),
    new Paragraph({
      children: [
        new TextRun({
          text: "A Cross-Platform Flutter, Firebase & AI-Vision Solution for Real-Time Household Waste Sorting, Citizen Gamification, and Sustainable Municipal Management Aligned with UN SDGs (SDG 11, SDG 12, SDG 13, SDG 3)",
          italics: true,
          size: 20,
          color: COLOR_DARK,
        }),
      ],
      alignment: AlignmentType.CENTER,
      spacing: { before: 40, after: 260 },
    })
  );

  // Student & Project Metadata Table
  const metaHeaders = ["Academic Field", "Project Record Information"];
  const metaRows = [
    ["Student Name", "P. Suresh"],
    ["University Roll Number", "24PA1A05I3"],
    ["Academic Programme", "Bachelor of Technology (B.Tech)"],
    ["Department & Class", "Computer Science and Engineering (CSE), 2nd Year"],
    ["Subject / Course", "Flutter Laboratory (SDG Embedded Practical Curriculum)"],
    ["Project Allocation S.No.", "S.No. 56: Household Waste Segregator"],
    ["Academic Institution", "Vishnu Institute of Technology (Autonomous), Bhimavaram"],
    ["Academic Year", "2026 – 2027"],
    ["GitHub Repository", "https://github.com/sureshpunnana-7794-arch/Household-Waste-Segregator"],
    ["Live Web Application", "https://sureshpunnana-7794-arch.github.io/Household-Waste-Segregator/"],
    ["VEDIC Portal Submission", "https://vedic.vishnu.edu.in/ (Vishnu Educational Development & Innovation Centre)"],
  ];
  elements.push(createTable(metaHeaders, metaRows, [34, 66]));
  elements.push(pageBreak());

  // ==========================================
  // RUBRICS & CERTIFICATE PAGE
  // ==========================================
  elements.push(
    h1("FLUTTER SDG PROJECT EVALUATION RUBRICS – 25 MARKS"),
    p(
      "The following official evaluation criteria are prescribed by Vishnu Institute of Technology, Bhimavaram for the assessment of Flutter SDG laboratory mini-projects. This project report, accompanying source code repository, and live demonstration have been structured to fulfill all expectations across each rubric dimension.",
      { color: COLOR_MUTED }
    )
  );

  const rubricHeaders = ["S.No.", "Evaluation Criteria", "Max Marks", "Compliance Highlights in EcoSort"];
  const rubricRows = [
    [
      "1",
      "UI/UX Design",
      "5",
      "Modern Material 3 interface, responsive bottom navigation, color-coded stream cards (Green Wet, Blue Dry, Bronze Metal, Purple Sanitary), animated scanner viewfinder, accessibility-tested.",
    ],
    [
      "2",
      "Functionality and Features",
      "7",
      "Smart AI Vision waste recognition, dual Firebase Auth (Guest + Email/Password), real-time Cloud Firestore synchronization, offline persistence, daily eco challenges, gamified points.",
    ],
    [
      "3",
      "Flutter Coding and Implementation",
      "5",
      "Clean Dart architecture, singleton service pattern, immutable models with JSON mapping, reactive Streams, optimistic UI updates, zero build errors across Web and Android targets.",
    ],
    [
      "4",
      "SDG Relevance and Social Impact",
      "3",
      "Direct alignment with UN SDG 12 (Target 12.5), SDG 11 (Target 11.6), SDG 13 (Climate Action / Methane avoidance), and SDG 3 (Sanitation worker safety). Quantitative carbon calculation formulas.",
    ],
    [
      "5",
      "GitHub Code Submission and VEDIC Portal Link",
      "2",
      "Clean public GitHub repository with comprehensive README, automated GitHub Actions workflow, deployed live GitHub Pages site, and verified VEDIC portal submission link.",
    ],
    [
      "6",
      "Project Documentation (Hard Copy and Soft Copy)",
      "3",
      "Comprehensive academic project record book delivered in both Microsoft Word (.docx) and printable PDF formats, including high-resolution live screenshots, architecture diagrams, and viva Q&A.",
    ],
    [
      "TOTAL",
      "Comprehensive Laboratory Evaluation",
      "25",
      "Targeted Full Score (25 / 25 Marks)",
    ],
  ];
  elements.push(createTable(rubricHeaders, rubricRows, [10, 28, 12, 50]));

  elements.push(
    h2("CERTIFICATE OF ORIGINAL WORK"),
    p(
      "This is to certify that the project entitled \"ECOSORT: SMART HOUSEHOLD WASTE SEGREGATOR\" is a bonafide record of independent laboratory work carried out by P. Suresh, bearing University Roll Number 24PA1A05I3, in partial fulfillment of the requirements for the Flutter Laboratory course in the Department of Computer Science and Engineering at Vishnu Institute of Technology (Autonomous), Bhimavaram during the academic year 2026–2027.",
      { italics: true }
    ),
    p(
      "The results embodied in this report have been independently verified through source code inspection, compilation of production Android Release APK, and public deployment on GitHub Pages.",
      { color: COLOR_MUTED }
    )
  );

  const certHeaders = ["Signatory", "Designation", "Date & Stamp"];
  const certRows = [
    ["Internal Faculty Guide", "Assistant Professor, Dept. of CSE", "March 2026"],
    ["Head of the Department", "Professor & HOD, Dept. of CSE", "March 2026"],
    ["External Examiner", "Academic / Industry Evaluator", "March 2026"],
  ];
  elements.push(createTable(certHeaders, certRows, [35, 35, 30]));
  elements.push(pageBreak());

  // ==========================================
  // ABSTRACT & TABLE OF CONTENTS
  // ==========================================
  elements.push(
    h1("EXECUTIVE ABSTRACT"),
    p(
      "Urban municipal solid waste management constitutes one of the most critical environmental and public health challenges confronting developing nations today. Across Indian cities and towns, unsegregated municipal solid waste is routinely dumped in open landfills, triggering toxic leachate infiltration into groundwater aquifers, uncontrolled anaerobic generation of methane (a potent greenhouse gas with 28 times the global warming potential of carbon dioxide), and severe bio-occupational hazards for frontline sanitation personnel."
    ),
    p(
      "The fundamental impediment to efficient waste management lies not in collection logistics, but at the point of origin: inside the household. Citizens frequently encounter cognitive ambiguity regarding material segregation standards, lack immediate quantitative feedback on their ecological contribution, and have no gamified incentive to sustain segregation discipline over time."
    ),
    p(
      "To resolve this bottleneck, EcoSort: Smart Household Waste Segregator is developed as a production-grade cross-platform application utilizing Flutter (Dart) and Google Firebase. EcoSort categorizes domestic waste into four standardized municipal streams: Wet Waste (biodegradable organic food scraps), Dry Waste (recyclable plastics, paper, and cardboards), Metallic Waste (infinitely recyclable aluminium and tins), and Sanitary Waste (hazardous domestic and hygiene items requiring safe incineration)."
    ),
    p(
      "The application incorporates a Smart AI Photo Scanner featuring camera and photo gallery capture, an animated optical laser reticle, and intelligent vision heuristics that identify waste materials, calculate classification confidence ratings, display recommended municipal bin colors, and estimate item weights. Integrated with Google Firebase, EcoSort provides real-time bidirectional synchronization with Cloud Firestore, authenticated user profiles via Firebase Auth, and an offline-first SQLite local persistence layer that guarantees seamless operation even during intermittent mobile internet connectivity."
    ),
    p(
      "Rigorous environmental algorithms convert logged waste data into actionable metrics: kilograms of carbon emissions avoided (1.417 kg CO2e per kg waste) and equivalent trees preserved (0.048 trees per kg). Gamified Eco Points, tiered level progression (Seedling to Earth Guardian), and daily eco challenges motivate continuous civic participation. The project directly advances United Nations Sustainable Development Goals (SDG 12: Target 12.5, SDG 11: Target 11.6, SDG 13: Target 13.3, and SDG 3: Target 3.9). The solution is fully deployed to production on GitHub Pages and compiled into an Android Release APK."
    ),
    callout(
      "Key Scientific & Technological Outcomes",
      "1. End-to-end multi-platform Flutter implementation (Android & Web) with zero syntax warnings.\n2. Smart AI camera scanning pipeline delivering instantaneous material identification.\n3. Cloud Firestore real-time synchronization with automatic offline-first local cache fallback.\n4. Complete alignment with UN SDGs 11, 12, 13, and 3 with verifiable mathematical environmental impact metrics."
    ),
    pageBreak()
  );

  return elements;
}

module.exports = { getTitlePageElements };
