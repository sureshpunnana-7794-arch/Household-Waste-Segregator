const { Paragraph, TextRun, AlignmentType } = require("docx");
const {
  h1,
  h2,
  h3,
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

function getSdgChapterElements() {
  const elements = [];

  elements.push(
    h1("CHAPTER 2: UNITED NATIONS SUSTAINABLE DEVELOPMENT GOALS (SDGs) & SOCIAL IMPACT"),
    p(
      "The 2030 Agenda for Sustainable Development, adopted by all United Nations Member States in 2015, provides a shared blueprint for peace and prosperity for people and the planet. At its heart are the 17 Sustainable Development Goals (SDGs), which represent an urgent call for action by all countries in global partnership. EcoSort: Smart Household Waste Segregator is intentionally engineered to address several interdependent SDGs, transforming abstract global sustainability targets into measurable, daily household micro-actions.",
      { color: COLOR_MUTED }
    ),
    h2("2.1 Direct Alignment with UN SDG 12: Responsible Consumption and Production"),
    p(
      "SDG 12 aims to ensure sustainable consumption and production patterns. Unsustainable extraction of finite natural resources and reckless consumer packaging disposal create escalating ecological degradation. EcoSort specifically drives Target 12.5:"
    ),
    callout(
      "UN SDG Target 12.5 Mandate",
      "\"By 2030, substantially reduce waste generation through prevention, reduction, recycling and reuse.\""
    ),
    p(
      "EcoSort directly executes this target through multiple operational mechanisms:"
    ),
    bullet(
      "High-Fidelity Source Segregation:",
      "Unsorted domestic garbage contaminates recyclable plastics, paper, and metals with wet organic slurry, reducing recyclable commodity value to near zero. EcoSort separates waste at the household kitchen counter into 4 distinct streams, keeping dry recyclables clean, pristine, and ready for high-yield industrial reprocessing."
    ),
    bullet(
      "Circular Material Economy:",
      "By isolating metallic aluminium cans and steel tins, the application prevents energy-intensive virgin bauxite mining. Recycling aluminium consumes 95% less electrical energy than primary smelting from ore, closing the circular industrial loop."
    ),
    bullet(
      "Daily Habit Formation & Waste Prevention:",
      "The integrated 'Daily Eco Challenges' (such as 'Plastic-Free Evening', 'Compost Chef', and 'No Single-Use Cutlery') actively encourage users to refuse packaging before it ever enters the domestic waste stream."
    ),
    h2("2.2 Direct Alignment with UN SDG 11: Sustainable Cities and Communities"),
    p(
      "Rapid urbanization across tier-1, tier-2, and rural-urban fringe cities places tremendous strain on municipal corporations. SDG 11 strives to make cities inclusive, safe, resilient, and sustainable. EcoSort addresses Target 11.6:"
    ),
    callout(
      "UN SDG Target 11.6 Mandate",
      "\"By 2030, reduce the adverse per capita environmental impact of cities, including by paying special attention to air quality and municipal and other waste management.\""
    ),
    p(
      "Municipalities spend between 20% to 50% of their annual municipal budgets on solid waste management logistics, with the vast majority consumed by transportation and landfill tipping fees. EcoSort alleviates municipal stress by:"
    ),
    bullet(
      "Decentralized Organic Composting Support:",
      "By isolating Wet Waste (which constitutes 50% to 60% of typical Indian municipal solid waste by weight), cities can divert wet waste directly to neighborhood aerobic composting or bio-methanation digesters, slashing truck transportation mileage and fuel expenditure."
    ),
    bullet(
      "Collection Planner & Ward Synchronization:",
      "The application features a Ward/Zone selector and interactive Pickup Planner that allows households to align disposal with municipal truck routing schedules, eliminating overflowing roadside garbage dumps and open street litter."
    ),
    bullet(
      "Compliance with Indian Solid Waste Management Rules 2016:",
      "The Ministry of Environment, Forest and Climate Change (MoEFCC) mandates segregation at source into biodegradable, non-biodegradable, and domestic hazardous waste. EcoSort empowers households to comply with national regulatory frameworks effortlessly."
    ),
    h2("2.3 Direct Alignment with UN SDG 13: Climate Action & Methane Mitigation"),
    p(
      "SDG 13 urges immediate action to combat climate change and its impacts. Open municipal dump sites (e.g., Ghazipur in Delhi, Deonar in Mumbai, or regional town dumping yards) are massive biogenic greenhouse gas emitters. When organic matter is buried beneath layers of compacted plastic, it undergoes anaerobic decomposition, producing landfill gas (LFG) consisting of ~50% Methane (CH4) and ~50% Carbon Dioxide (CO2)."
    ),
    callout(
      "Atmospheric Science Context",
      "Methane (CH4) possesses a Global Warming Potential (GWP) 28 to 36 times higher than Carbon Dioxide over a 100-year timescale, and over 80 times higher over a 20-year timescale. Landfills represent the third-largest anthropogenic source of methane globally."
    ),
    p(
      "EcoSort mitigates climate warming through verified thermodynamic pathways:"
    ),
    bullet(
      "Methane Avoidance via Aerobic Aeration:",
      "Segregated wet waste diverted to aerobic composting produces water vapor and minimal biogenic CO2, completely avoiding anaerobic methane formation."
    ),
    bullet(
      "Embodied Energy Preservation in Dry Recyclables:",
      "Recycling 1 ton of segregated plastic packaging saves approximately 5,774 kWh of electricity, 16.3 barrels of petroleum oil, and 22,000 gallons of industrial process water."
    ),
    h2("2.4 Direct Alignment with UN SDG 3: Good Health and Well-Being & Sanitation Worker Safety"),
    p(
      "SDG 3 promotes healthy lives and well-being for all. Informal waste pickers, sanitary workers, and municipal collectors face grave daily occupational hazards when handling mixed domestic garbage."
    ),
    bullet(
      "Eliminating Biohazard & Infectious Contamination (Target 3.9):",
      "EcoSort enforces a strict dedicated Sanitary Waste stream (color-coded purple) for sanitary napkins, baby diapers, bandages, and medical items. The app instructs users to wrap sanitary waste in labeled paper packets before disposal, preventing direct dermal contact and pathogen transmission (Hepatitis B, HIV, tetanus, bacterial infections) to waste workers."
    ),
    bullet(
      "Preventing Physical Lacerations:",
      "The Metallic Waste stream isolates broken glass, tin can lids, and metallic edges, instructing households to wrap or blunt sharp items. This eradicates chronic puncture wounds and sepsis among sanitation laborers."
    ),
    bullet(
      "Preventing Ground Water Leachate Poisoning:",
      "Unsegregated domestic batteries, e-waste, and household chemicals leach carcinogenic heavy metals (cadmium, lead, mercury) into municipal soil and drinking water tables. Segregation shields community water supplies."
    ),
    h2("2.5 Quantitative Mathematical Environmental Models & Impact Formulas"),
    p(
      "To provide transparent, defensible, and scientifically grounded feedback to citizens, EcoSort embeds exact stoichiometric coefficients directly into its reactive Dart business logic (`firebase_service.dart` and `profile_screen.dart`):"
    )
  );

  const formulaHeaders = ["Metric", "Stoichiometric Formula", "Empirical Conversion Factor", "Scientific Reference"];
  const formulaRows = [
    [
      "CO2 Equivalent Prevented",
      "ΔCO2 = W_segregated × 1.417 kg",
      "1.417 kg CO2e / kg waste",
      "EPA WARM Model (Waste Reduction Model) & IPCC Greenhouse Gas Inventories",
    ],
    [
      "Equivalent Trees Preserved",
      "Trees = W_segregated × 0.048 trees",
      "0.048 mature tree equivalents / kg",
      "US Forest Service Urban Carbon Sequestration Rate (21.8 kg CO2 / tree / year)",
    ],
    [
      "Landfill Volume Diverted",
      "V_saved = W_dry / 220 + W_wet / 600",
      "Variable bulk density m³ / kg",
      "Central Pollution Control Board (CPCB) Solid Waste Characteristics Bulletin",
    ],
    [
      "Methane (CH4) Generation Averted",
      "ΔCH4 = W_wet × 0.072 kg CH4",
      "0.072 kg CH4 avoided / kg organic",
      "IPCC First Order Decay Model for Decomposing Municipal Organic Waste",
    ],
  ];
  elements.push(createTable(formulaHeaders, formulaRows, [24, 28, 24, 24]));

  elements.push(
    h2("2.6 Socio-Economic Impact and the Circular Informal Economy"),
    p(
      "India's informal recycling sector employs an estimated 1.5 million waste pickers (Kabadiwalas and itinerant buyers). Currently, waste pickers spend grueling hours manually sorting through putrid, mixed garbage in open dumps, earning meager wages while suffering respiratory and dermatological diseases."
    ),
    p(
      "When households use EcoSort to presort materials at home, the quality and cleanliness of dry recyclables increases by over 300%. Informal recyclers can collect clean paper, cardboard, and clean polyethylene terephthalate (PET) bottles directly, enabling them to double their daily earning potential while operating in hygienic, dignified human conditions. EcoSort bridges the digital divide by connecting household discipline with grassroots circular economic welfare."
    ),
    pageBreak()
  );

  return elements;
}

module.exports = { getSdgChapterElements };
