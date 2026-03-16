export interface QuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctIndex: number;
  difficulty: 1 | 2 | 3;
  relatedCardId: string;
  explanation: string;
  type: 'term-to-def' | 'def-to-term' | 'hebrew' | 'seder' | 'fill-blank';
}

export const quizQuestions: QuizQuestion[] = [
  // ─── Term-to-Definition Questions ────────────────────────────────
  {
    id: 'q1',
    question: 'What is "Halachah"?',
    options: [
      'A specific prayer recited on Shabbat',
      'Jewish religious law derived from the Torah and rabbinic tradition',
      'The Hebrew word for "synagogue"',
      'A type of biblical commentary',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'halachah',
    explanation:
      'Halachah literally means "the way to walk" and encompasses all of Jewish law — from biblical commandments to rabbinic enactments and customs.',
    type: 'term-to-def',
  },
  {
    id: 'q2',
    question: 'What is the Mishnah?',
    options: [
      'The Five Books of Moses',
      'A medieval law code by Maimonides',
      'The first major written compilation of the Oral Torah, compiled around 200 CE',
      'The commentary section of the Talmud',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'mishnah',
    explanation:
      'The Mishnah was compiled by Rabbi Yehudah HaNasi around 200 CE. It organized the Oral Torah into six orders and became the foundation for the Talmud.',
    type: 'term-to-def',
  },
  {
    id: 'q3',
    question: 'What is the Gemara?',
    options: [
      'The Written Torah',
      'Rabbinic commentary and analysis of the Mishnah, forming part of the Talmud',
      'A collection of prayers for daily use',
      'The six orders of the Mishnah',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'gemara',
    explanation:
      'The Gemara (from Aramaic "gamar," to complete) is the extensive rabbinic discussion of the Mishnah. Together, the Mishnah and Gemara form the Talmud.',
    type: 'term-to-def',
  },
  {
    id: 'q4',
    question: 'What is a "Baraita"?',
    options: [
      'A section of the Written Torah',
      'A Tanaitic teaching not included in the Mishnah but quoted in the Gemara',
      'A type of Talmudic page layout',
      'An Aramaic prayer recited in synagogue',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'baraita',
    explanation:
      '"Baraita" means "outside" in Aramaic — these are teachings from the Tanaitic period that were left outside the Mishnah but preserved in the Gemara.',
    type: 'term-to-def',
  },
  {
    id: 'q5',
    question: 'What does the term "Shas" refer to?',
    options: [
      'The Shulchan Aruch',
      'The six orders of the Mishnah/Talmud (an acronym for Shishah Sedarim)',
      'A single tractate of the Talmud',
      'The chain of oral transmission from Sinai',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'shas',
    explanation:
      'Shas is an acronym for "Shishah Sedarim" (Six Orders) and is used as a common name for the entire Talmud.',
    type: 'term-to-def',
  },

  // ─── Definition-to-Term Questions ────────────────────────────────
  {
    id: 'q6',
    question: 'Which term refers to the rabbinic sages whose teachings are recorded in the Mishnah (active ~10–200 CE)?',
    options: [
      'Amora\'im',
      'Geonim',
      'Tana\'im',
      'Rishonim',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'tanaim',
    explanation:
      'The Tana\'im (from Aramaic "tana," to teach) were the earlier sages whose rulings form the Mishnah. The Amora\'im came later and produced the Gemara.',
    type: 'def-to-term',
  },
  {
    id: 'q7',
    question: 'Which term describes the process of organizing laws into a systematic, written code?',
    options: [
      'Extrapolate',
      'Canonize',
      'Codify',
      'Transmit',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'codify',
    explanation:
      'Codification is the process of organizing and systematizing laws into a clear code. Maimonides\' Mishneh Torah and Karo\'s Shulchan Aruch are major examples of codification in Jewish law.',
    type: 'def-to-term',
  },
  {
    id: 'q8',
    question: 'Which text is the authoritative code of Jewish law compiled by Rabbi Yosef Karo in 1565?',
    options: [
      'Mishneh Torah',
      'Shulchan Aruch',
      'Mishnah',
      'Tosefta',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'shulchan-aruch',
    explanation:
      'The Shulchan Aruch ("Set Table") was compiled by Rabbi Yosef Karo. Rabbi Moshe Isserles (Rema) added Ashkenazi glosses called the Mappah ("Tablecloth").',
    type: 'def-to-term',
  },
  {
    id: 'q9',
    question: 'Which term refers to the officially accepted collection of books considered authoritative scripture?',
    options: [
      'Apocrypha',
      'Responsa',
      'Canon',
      'Codex',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'canon',
    explanation:
      'The canon is the official list of authoritative scriptural books. The Jewish canon consists of the 24 books of the Tanach.',
    type: 'def-to-term',
  },
  {
    id: 'q10',
    question: 'Which sages produced the Gemara by analyzing and debating the Mishnah (~200–500 CE)?',
    options: [
      'Tana\'im',
      'Amora\'im',
      'Rishonim',
      'Acharonim',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'amoraim',
    explanation:
      'The Amora\'im (from Aramaic "amar," to say/interpret) analyzed the Mishnah in both Babylonia and the Land of Israel, producing the two Talmuds.',
    type: 'def-to-term',
  },

  // ─── Hebrew Questions ────────────────────────────────────────────
  {
    id: 'q11',
    question: 'What does "תּוֹרָה שֶׁבְּעַל פֶּה" (Torah SheBa\'al Peh) mean?',
    options: [
      'The Written Torah',
      'The Oral Torah',
      'The Five Books of Moses',
      'The Prophetic books',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'torah-shebalpe',
    explanation:
      '"Ba\'al Peh" means "by mouth." Torah SheBa\'al Peh is the Oral Torah — transmitted orally from Sinai and later written in the Mishnah and Talmud.',
    type: 'hebrew',
  },
  {
    id: 'q12',
    question: 'The Hebrew term "מַחְלֹקֶת" (Machloket) refers to what?',
    options: [
      'A tractate of the Talmud',
      'A halachic disagreement or dispute between sages',
      'A prayer recited during holidays',
      'A type of biblical commentary',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'machloket',
    explanation:
      'Machloket (from the root ch-l-k, to divide) is a dispute between sages. The Talmud preserves these disputes as all opinions are considered valuable.',
    type: 'hebrew',
  },
  {
    id: 'q13',
    question: 'What does the Hebrew "בָּרַיְתָא" mean?',
    options: [
      'Inside teaching',
      'Outside teaching — a Tanaitic teaching not included in the Mishnah',
      'A written scroll',
      'A legal ruling by the Amora\'im',
    ],
    correctIndex: 1,
    difficulty: 3,
    relatedCardId: 'baraita',
    explanation:
      '"Baraita" means "outside" in Aramaic, referring to Tanaitic teachings left outside the official Mishnah compilation but quoted in the Gemara.',
    type: 'hebrew',
  },

  // ─── Seder (Six Orders) Questions ────────────────────────────────
  {
    id: 'q14',
    question: 'Which Seder (order) of the Mishnah deals with Shabbat and holiday observances?',
    options: [
      'Zeraim (Seeds)',
      'Moed (Festivals)',
      'Nashim (Women)',
      'Kodashim (Holy Things)',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'moed',
    explanation:
      'Moed ("Appointed Time") is the second order and covers Shabbat, the pilgrimage festivals, Rosh Hashanah, Yom Kippur, Purim, and fast days.',
    type: 'seder',
  },
  {
    id: 'q15',
    question: 'Which Seder of the Mishnah covers civil and criminal law, courts, and ethics?',
    options: [
      'Nashim (Women)',
      'Tohorot (Purities)',
      'Nezikin (Damages)',
      'Zeraim (Seeds)',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'nezikin',
    explanation:
      'Nezikin ("Damages") covers torts, property law, courts, and also contains Pirkei Avot (Ethics of the Fathers).',
    type: 'seder',
  },
  {
    id: 'q16',
    question: 'Which is the correct order of the six Sedarim of the Mishnah?',
    options: [
      'Moed, Zeraim, Nezikin, Nashim, Tohorot, Kodashim',
      'Zeraim, Moed, Nashim, Nezikin, Kodashim, Tohorot',
      'Nashim, Moed, Zeraim, Kodashim, Nezikin, Tohorot',
      'Zeraim, Nashim, Moed, Kodashim, Tohorot, Nezikin',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'seder',
    explanation:
      'The six orders in sequence are: Zeraim (Seeds), Moed (Festivals), Nashim (Women), Nezikin (Damages), Kodashim (Holy Things), Tohorot (Purities).',
    type: 'seder',
  },
  {
    id: 'q17',
    question: 'Which Seder deals with Temple sacrifices and ritual slaughter?',
    options: [
      'Tohorot (Purities)',
      'Nezikin (Damages)',
      'Kodashim (Holy Things)',
      'Moed (Festivals)',
    ],
    correctIndex: 2,
    difficulty: 2,
    relatedCardId: 'kodashim',
    explanation:
      'Kodashim ("Holy Things") covers Temple sacrifices, meal offerings, the daily Temple ritual, and kosher slaughter (in Tractate Chullin).',
    type: 'seder',
  },

  // ─── Fill-in-the-Blank Questions ─────────────────────────────────
  {
    id: 'q18',
    question: 'Complete the formula: Talmud = Mishnah + _____',
    options: [
      'Torah',
      'Gemara',
      'Tanach',
      'Responsa',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'talmud',
    explanation:
      'The Talmud consists of the Mishnah (the compiled Oral Torah) plus the Gemara (rabbinic analysis and commentary on the Mishnah).',
    type: 'fill-blank',
  },
  {
    id: 'q19',
    question: 'Complete the quote from Pirkei Avot 1:1: "Moses received the Torah from Sinai and transmitted it to _____."',
    options: [
      'The Prophets',
      'The Elders',
      'Joshua',
      'The Men of the Great Assembly',
    ],
    correctIndex: 2,
    difficulty: 2,
    relatedCardId: 'pirkei-avot-1-1',
    explanation:
      'The chain of transmission: Moses → Joshua → Elders → Prophets → Men of the Great Assembly. Moses first transmitted the Torah to Joshua.',
    type: 'fill-blank',
  },
  {
    id: 'q20',
    question: 'The Torah says "Do not cook a kid in its mother\'s milk." The Oral Torah extrapolates this into a prohibition against mixing any _____ with any _____.',
    options: [
      'grain ... legume',
      'meat ... dairy',
      'wine ... bread',
      'fish ... poultry',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'milk-meat-oral-law',
    explanation:
      'The Oral Torah derived three prohibitions from the three biblical repetitions: no cooking, eating, or deriving benefit from meat-dairy mixtures. This is a classic example of extrapolation.',
    type: 'fill-blank',
  },

  // ─── Additional Questions ────────────────────────────────────────
  {
    id: 'q21',
    question: 'What is the Bavli?',
    options: [
      'The Jerusalem Talmud',
      'A medieval law code',
      'The Babylonian Talmud — the larger and more widely studied of the two Talmuds',
      'A collection of prophetic writings',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'bavli',
    explanation:
      'The Bavli (Babylonian Talmud) was compiled in the academies of Sura and Pumbedita in Babylonia (~500 CE). It is roughly three times the size of the Yerushalmi and is the more authoritative Talmud.',
    type: 'term-to-def',
  },
  {
    id: 'q22',
    question: 'Tefillin are an example of what principle?',
    options: [
      'The Written Torah contains all the details needed for observance',
      'The Oral Torah is necessary because the Written Torah lacks critical details',
      'Rabbinic law supersedes biblical law',
      'Customs are more important than commandments',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'tefillin-oral-law',
    explanation:
      'The Torah says "bind them as a sign" but never explains what tefillin are, their shape, contents, or how to wear them. Every detail comes from the Oral Torah.',
    type: 'def-to-term',
  },
  {
    id: 'q23',
    question: 'What does "דַּף" (Daf) mean in the context of Talmud study?',
    options: [
      'A chapter',
      'A tractate',
      'A page or folio with two sides (amud a and amud b)',
      'An order of the Mishnah',
    ],
    correctIndex: 2,
    difficulty: 2,
    relatedCardId: 'daf',
    explanation:
      'A daf is a page (folio) of the Talmud. Each daf has two sides: amud alef (a) and amud bet (b). The page numbering has been standardized since the Bomberg edition of 1520–1523.',
    type: 'hebrew',
  },
  {
    id: 'q24',
    question: 'How does Rambam (Maimonides) differ from Saadiah Gaon regarding the Oral Torah?',
    options: [
      'Rambam rejected the Oral Torah; Saadiah accepted it',
      'Rambam saw it as complete divine transmission from Sinai; Saadiah emphasized human reason alongside tradition',
      'Saadiah wrote the Mishneh Torah; Rambam wrote responsa',
      'They held identical views on the Oral Torah',
    ],
    correctIndex: 1,
    difficulty: 3,
    relatedCardId: 'rambam-vs-saadiah',
    explanation:
      'Rambam held that every detail of the Oral Torah was given at Sinai. Saadiah Gaon, while affirming divine origin, emphasized the legitimate role of human reason in interpreting and developing the law.',
    type: 'def-to-term',
  },
  {
    id: 'q25',
    question: 'The Tanach is an acronym. What do the three letters stand for?',
    options: [
      'Talmud, Nevi\'im, Ketuvim',
      'Torah, Nevi\'im, Ketuvim',
      'Torah, Niddah, Kodashim',
      'Tana\'im, Nezikin, Ketubot',
    ],
    correctIndex: 1,
    difficulty: 1,
    relatedCardId: 'tanach',
    explanation:
      'TaNaKh stands for Torah (Teaching/Law), Nevi\'im (Prophets), and Ketuvim (Writings) — the three sections of the Hebrew Bible, containing 24 books total.',
    type: 'fill-blank',
  },
  {
    id: 'q26',
    question: 'What are the Apocrypha?',
    options: [
      'The six orders of the Mishnah',
      'Jewish texts from the Second Temple period excluded from the Jewish canon',
      'Commentaries on the Shulchan Aruch',
      'The collected responsa of the Geonim',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'apocrypha',
    explanation:
      'The Apocrypha ("hidden away") includes books like Maccabees, Sirach, and Tobit — written during the Second Temple period but excluded from the Jewish biblical canon.',
    type: 'term-to-def',
  },
  {
    id: 'q27',
    question: 'Which Seder of the Mishnah deals with agricultural laws and also contains Tractate Berakhot on blessings?',
    options: [
      'Moed (Festivals)',
      'Zeraim (Seeds)',
      'Tohorot (Purities)',
      'Nashim (Women)',
    ],
    correctIndex: 1,
    difficulty: 2,
    relatedCardId: 'zeraim',
    explanation:
      'Zeraim ("Seeds") covers agricultural laws. Tractate Berakhot is placed here because blessings over food connect to the agricultural theme. Only Berakhot has Gemara in the Bavli.',
    type: 'seder',
  },
  {
    id: 'q28',
    question: 'What does "extrapolate" mean in the context of Talmudic reasoning?',
    options: [
      'To reject a teaching based on a contradictory source',
      'To copy a text word for word from another source',
      'To derive new conclusions by extending known principles to new situations',
      'To translate Hebrew into Aramaic',
    ],
    correctIndex: 2,
    difficulty: 2,
    relatedCardId: 'extrapolate',
    explanation:
      'Extrapolation is central to halachic development — taking Torah principles and extending them to cover situations not explicitly addressed in the biblical text.',
    type: 'term-to-def',
  },
  {
    id: 'q29',
    question: 'What is a "Masechet"?',
    options: [
      'One of the six orders of the Mishnah',
      'A page of the Talmud',
      'A tractate — a thematic subdivision within a seder focusing on a specific area of law',
      'A dispute between two sages',
    ],
    correctIndex: 2,
    difficulty: 1,
    relatedCardId: 'masechet',
    explanation:
      'A masechet (tractate) is a thematic unit within a seder. There are 63 masekhtot total. The word means "weaving" — legal threads woven into a coherent discussion.',
    type: 'term-to-def',
  },
  {
    id: 'q30',
    question: 'According to Rambam\'s reading of Exodus 24:12, "the Torah" refers to the Written Torah and "the commandment" refers to what?',
    options: [
      'The Ten Commandments specifically',
      'The Oral Torah — its explanation',
      'The laws of the Temple',
      'The teachings of the Prophets',
    ],
    correctIndex: 1,
    difficulty: 3,
    relatedCardId: 'rambam-exodus-24',
    explanation:
      'Maimonides explains Exodus 24:12: "the Torah" = Written Torah; "the commandment" = its oral explanation (the Oral Torah). Both were given to Moses at Sinai.',
    type: 'fill-blank',
  },
];

export default quizQuestions;
