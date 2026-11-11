const { Paragraph, TextRun, AlignmentType } = require("docx");
const {
  h1,
  h2,
  p,
  bullet,
  callout,
  imageFigure,
  pageBreak,
  COLOR_PRIMARY,
  COLOR_MUTED,
  COLOR_DARK,
} = require("../helpers");

function getScreenshotsChapterElements() {
  const elements = [];

  elements.push(
    h1("CHAPTER 7: APPLICATION SCREENS, SCREENSHOTS & UI/UX OUTPUTS"),
    p(
      "This chapter presents the actual, live production outputs of EcoSort: Smart Household Waste Segregator running natively on a mobile device and deployed on the web. Each figure illustrates key UI/UX design choices, interactive components, Material 3 styling tokens, and the real-time feedback mechanisms that drive user engagement and compliance with municipal solid waste segregation guidelines.",
      { color: COLOR_MUTED }
    ),
    h2("7.1 Figure 7.1: EcoSort Home Dashboard Screen"),
    p(
      "The Home Dashboard serves as the central operational hub upon launching the application. At the top, the app displays the branded app bar with the cloud synchronization status badge ('Firebase Live Sync') and the profile avatar button."
    ),
    p(
      "A hero eco card prominently features the motivating motto 'MAKE EVERY WASTE COUNT', summarizing total household waste logged (2.4 kg), total accumulated Eco Points (120 ECO POINTS), and total segregation entries (3 ENTRIES), alongside an immediate 'Add waste' call-to-action button."
    ),
    p(
      "Directly below, the 'Smart AI Photo Scanner' launch banner offers 1-tap navigation to the camera scanning pipeline. The 'Your waste at a glance' section organizes the four municipal streams into clean, elevated Material cards: Wet Waste (0.8 kg), Dry Waste (1.2 kg), Metallic (0.4 kg), and Sanitary (0.0 kg). A prominent green Floating Action Button ('Smart Scan') provides persistent scanner access."
    )
  );

  // Embed Screenshot 1
  elements.push(
    ...imageFigure(
      "screen1_home_dashboard.jpg",
      "7.1",
      "EcoSort Home Dashboard & Quick Glance Metrics",
      "Live mobile screen displaying hero eco card, 120 Eco Points, 2.4 kg recorded waste, Smart AI Photo Scanner banner, and 4-stream glance cards."
    ),
    pageBreak(),
    h2("7.2 Figure 7.2: Daily Eco Challenge & Recent Waste Activity Feed"),
    p(
      "Scrolling down the Home Dashboard reveals the gamification and activity tracking components. The 'Today's eco challenge' banner introduces a daily sustainability micro-habit: 'Plastic-free evening — Avoid single-use plastic today to earn bonus points', complete with an interactive 'Claim +20' reward button."
    ),
    p(
      "The 'Recent activity' feed renders a chronological stream of recorded waste items synced in real time with Cloud Firestore. In this live session, recent entries include: 'Aluminium beverage cans' (Metallic, 0.4 kg, logged Nov 10, 9:22 PM), 'Cardboard & paper packaging' (Dry waste, 1.2 kg, logged Nov 11, 3:22 PM), and 'Vegetable & fruit peels' (Wet waste, 0.8 kg, logged Nov 11, 6:22 PM). Each item displays its category icon, timestamp, logged weight, and an interactive delete icon."
    )
  );

  // Embed Screenshot 2
  elements.push(
    ...imageFigure(
      "screen2_recent_activity.jpg",
      "7.2",
      "Daily Eco Challenge & Recent Waste Activity Feed",
      "Live screen displaying today's plastic-free eco challenge (+20 pts) and chronological waste log entries with exact weights and timestamps."
    ),
    pageBreak(),
    h2("7.3 Figure 7.3: 4-Stream Waste Segregation Interface"),
    p(
      "Navigating to the 'Segregate' tab opens the comprehensive multi-stream categorization interface. A prominent banner at the top enables users to 'Launch Smart Photo Scan' for automatic camera recognition."
    ),
    p(
      "Below the banner, four distinct, color-coded stream cards present explicit municipal sorting instructions: (1) Wet waste (green card, 0.8 kg) for fruit peels, food leftovers, tea leaves, and vegetable scraps; (2) Dry waste (blue card, 1.2 kg) for paper, cardboard boxes, clean plastic containers; (3) Metallic waste (bronze card, 0.4 kg) for aluminium cans, tins, bottle caps, and iron scraps; and (4) Sanitary waste (purple card, 0.0 kg) for diapers, sanitary pads, medical swabs, and tissues. Tapping the '+' button on any card opens a validated manual entry dialog."
    )
  );

  // Embed Screenshot 3
  elements.push(
    ...imageFigure(
      "screen3_sort_waste.jpg",
      "7.3",
      "4-Stream Municipal Waste Segregation Interface",
      "Live segregation screen displaying detailed guidance and current weights for Wet, Dry, Metallic, and Sanitary municipal streams."
    ),
    pageBreak(),
    h2("7.4 Figure 7.4: Smart AI Waste Scanner with Laser Viewfinder"),
    p(
      "Tapping 'Scan' from the bottom navigation or the floating action button opens the Smart AI Waste Scanner. The interface switches to a dark, high-contrast camera preview mode featuring a rounded alignment reticle and an animated horizontal scanning laser beam that oscillates vertically to guide the user in framing the waste item."
    ),
    p(
      "Users can capture a photograph using 'Take Photo' or pick an existing image via 'Gallery'. To support rapid testing, demonstration, and evaluation, the screen includes an 'Instant Test Samples' row featuring one-tap preset items: Plastic Bottle, Veggie Peel, Soda Can, and Cardboard Box. Selecting any preset simulates instant optical inference, displaying confidence percentages, bin recommendations, and recyclability ratings."
    )
  );

  // Embed Screenshot 4
  elements.push(
    ...imageFigure(
      "screen4_smart_scanner.jpg",
      "7.4",
      "Smart AI Waste Scanner with Optical Laser Viewfinder",
      "Live scanner screen showing the animated laser targeting frame, Take Photo and Gallery triggers, and instant test sample presets."
    ),
    pageBreak(),
    h2("7.5 Figure 7.5: Green Impact Analytics & Municipal Pickup Planner"),
    p(
      "The 'Guide' / Impact tab visualizes the long-term ecological contribution of the household. A large dark green impact card displays 'TOTAL WASTE RECORDED: 2.4 kg' with the inspiring reminder: 'Every separated item is a step towards a cleaner community.'"
    ),
    p(
      "The 'Category distribution' card renders horizontal progress bars indicating the proportional breakdown: Wet waste (0.8 kg), Dry waste (1.2 kg), Metallic (0.4 kg), and Sanitary (0.0 kg). A cloud badge reassures the user that 'All data is synchronized with Firebase and backed by offline local cache'."
    ),
    p(
      "Underneath, the 'Collection planner' card ('Plan a waste pickup') provides an interactive calendar picker enabling households to schedule collection day reminders aligned with municipal sanitation truck visits."
    )
  );

  // Embed Screenshot 5
  elements.push(
    ...imageFigure(
      "screen5_green_impact.jpg",
      "7.5",
      "Green Impact Analytics, Category Distribution & Pickup Planner",
      "Live impact screen showing cumulative waste weight (2.4 kg), category distribution progress bars, Firebase sync badge, and collection planner."
    ),
    pageBreak(),
    h2("7.6 Figure 7.6: User Profile, Household Settings & Reminders"),
    p(
      "The 'Profile' tab presents comprehensive identity, gamification, and municipal settings. The top user card identifies the active user: 'Suresh Punnana (Guest Explorer / Local Mode)' with a green verified 'Cloud Synced' badge. An edit icon allows inline display name updates."
    ),
    p(
      "The gamified status section shows 'Level 2: Green Sprout' with a progress bar at '120 / 150 pts', motivating the user to reach Level 3: Eco Warrior. The 'Your Lifetime Impact' row displays three calculated environmental metrics: 2.4 kg Waste Sorted, 3.4 kg CO2 Prevented, and 0.1 Trees Saved."
    ),
    p(
      "The 'Household & Waste Settings' section allows custom calibration: (1) 'Household Members' dropdown set to '3-4 people' to calibrate daily waste benchmarks; (2) 'Collection Ward / Zone' set to 'Ward 14 - Green Hills Sector'; and (3) 'Morning Reminder (8:00 AM)' switch toggled ON to trigger daily segregation alarms."
    )
  );

  // Embed Screenshot 6
  elements.push(
    ...imageFigure(
      "screen6_profile_settings.jpg",
      "7.6",
      "User Profile, Lifetime Impact & Household Settings",
      "Live profile screen showing user Suresh Punnana, Level 2 Green Sprout (120 pts), lifetime carbon/tree impact, household size, ward, and 8:00 AM reminder."
    ),
    pageBreak()
  );

  return elements;
}

module.exports = { getScreenshotsChapterElements };
