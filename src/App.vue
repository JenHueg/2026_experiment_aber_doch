# App.vue

<template>

  <div>

    <!-- ==================================================
         START
         ================================================== -->
    <StartPage
      v-if="page === 'start'"
      @next="page = 'instructions'"
    />

    <!-- ==================================================
         INSTRUCTIONS
         ================================================== -->

    <InstructionPage
      v-if="page === 'instructions'"
      @next="startExperiment"
    />

    <!-- ==================================================
         BLOCK 1
         ================================================== -->

    <TrialPage
      key="block1"
      v-if="page === 'block1'"
      :stimuli="block1"
      :totalTrials="totalTrials"
      :startIndex="0"
      :participantID="participantID"
      :comprehensionTrials="comprehensionTrials"
      @finished="finishBlock1"
    />

    <!-- ==================================================
         BREAK
         ================================================== -->

    <BreakPage
      v-if="page === 'break'"
      @next="startBlock2"
    />

    <!-- ==================================================
         BLOCK 2
         ================================================== -->

    <TrialPage
      key="block2"
      v-if="page === 'block2'"
      :stimuli="block2"
      :totalTrials="totalTrials"
      :startIndex="block1.length"
      :participantID="participantID"
      :comprehensionTrials="comprehensionTrials"
      @finished="finishExperiment"
    />

    <!-- ==================================================
         DEMOGRAPHICS
         ================================================== -->

    <DemographicsPage
      v-if="page == 'demographics'"
      @finished="saveDemographics"
    />

    <!-- ==================================================
         END
         ================================================== -->

    <EndPage
      v-if="page === 'end'"
    />

  </div>

</template>


<script>

import Papa from 'papaparse'

import StartPage from './components/StartPage.vue'
import InstructionPage from './components/InstructionPage.vue'
import TrialPage from './components/TrialPage.vue'
import BreakPage from './components/BreakPage.vue'
import DemographicsPage from './components/DemographicsPage.vue'
import EndPage from './components/EndPage.vue'

export default {

  components: {
    StartPage,
    InstructionPage,
    TrialPage,
    BreakPage,
    DemographicsPage,
    EndPage
  },


  // ==================================================
  // DATA
  // ==================================================

  data() {

    return {
      page: 'start',
      block1: [],
      block2: [],
      responses: [],
      selectedList: '',
      totalTrials: 0,
      participantID: '',
      experimentStartTime: null,
      experimentDuration: '',

      // ==================================================
      // COMPREHENSION TRIALS
      //
      // Hier werden die GLOBALEN Indizes der Trials
      // gespeichert, die eine Comprehension Question
      // bekommen.
      //
      // Beispiel:
      //
      // [1, 4, 7]
      //
      // bedeutet:
      //
      // Trial 1 -> Frage
      // Trial 4 -> Frage
      // Trial 7 -> Frage
      // ==================================================

      comprehensionTrials: [],

      // ==================================================
      // DEMOGRAPHICS
      // ==================================================

      demographics: {
        age: '',
        gender: '',
        genderSelfDescription: '',
        nativeLanguage: ''
      }
    }
  },

  // ==================================================
  // METHODS
  // ==================================================

  methods: {

    // ==================================================
    // START EXPERIMENT
    // ==================================================

    async startExperiment() {
      console.log(
        'START EXPERIMENT'
      )

      // ------------------------------------------------
      // Participant ID
      // ------------------------------------------------

      this.participantID = crypto.randomUUID()

      // ------------------------------------------------
      // STARTING TIME
      // ------------------------------------------------

      this.experimentStartTime =
        Date.now()

      // ==================================================
      // LOAD CSV
      // ==================================================

      const response =
        await fetch('/stimuli.csv')

      const csvText =
        await response.text()

      // ==================================================
      // PARSE CSV
      // ==================================================

      const parsed =
        Papa.parse(csvText, {
          header: true,
          skipEmptyLines: true
        })

      console.log(
        'CSV loaded:',
        parsed.data
      )

      // ==================================================
      // FILTER STIMULI
      // ==================================================

      let allStimuli =
        parsed.data.filter(item =>
          item.item &&
          item.list &&
          item.statement &&
          item.denial 
        )

      console.log(
        'Stimuli length:',
        allStimuli.length
      )

      // ==================================================
      // FIND AVAILABLE LISTS
      // ==================================================

      const allLists = [
        ...new Set(
          allStimuli.map(
            item =>
              item.list.trim()
          )
        )
      ]

      console.log(
        'Available Lists:',
        allLists
      )

      // ==================================================
      // PICK RANDOM LIST
      // ==================================================

      const randomIndex =
        Math.floor(
          Math.random() *
          allLists.length
        )

      this.selectedList =
        allLists[randomIndex]

      console.log(
        'Picked list:',
        this.selectedList
      )

      // ==================================================
      // KEEP ONLY PICKED LIST
      // ==================================================

      let stimuli =
        parsed.data.filter(
          item =>
            item.list.trim() ===
            this.selectedList
        )

      console.log(
        'Stimuli of picked list:',
        stimuli
      )

      // ==================================================
      // RANDOMIZE ORDER
      // ==================================================

      stimuli = this.shuffle(stimuli)

      console.log(
        'Randomized item order:',
        stimuli.map(item => item.item)
      )

      // ==================================================
      // TOTAL NUMBER
      // ==================================================

      this.totalTrials =
        stimuli.length

      console.log(
        'Total number trials:',
        this.totalTrials
      )

      // ==================================================
      // PICK COMPREHENSION TRIALS 
      //
      // IMPORTANT:
      //
      // This does not happen after randomisation. 
      //
      // Dadurch beziehen sich die Indizes auf die
      // tatsächliche Reihenfolge, in der die Trials
      // präsentiert werden.
      // ==================================================


      const numberOfComprehensionQuestions =

        Math.max(

          1,

          Math.round(
            this.totalTrials / 3
          )

        )


      console.log(
        'Anzahl geplanter Comprehension Questions:',
        numberOfComprehensionQuestions
      )


      // ------------------------------------------------
      // Alle globalen Trial-Indizes erzeugen
      // ------------------------------------------------

      const allIndices =

        stimuli.map(
          (item, index) =>
            index
        )


      console.log(
        'Alle Trial-Indizes:',
        allIndices
      )


      // ------------------------------------------------
      // Indizes zufällig mischen
      // ------------------------------------------------

      const shuffledIndices =
        this.shuffle(
          [...allIndices]
        )


      console.log(
        'Zufällig gemischte Indizes:',
        shuffledIndices
      )


      // ------------------------------------------------
      // Erstes Drittel auswählen
      // ------------------------------------------------

      this.comprehensionTrials =

        shuffledIndices.slice(
          0,
          numberOfComprehensionQuestions
        )


      // ------------------------------------------------
      // Zur Sicherheit sortieren
      //
      // Das ist NICHT notwendig für die Auswahl.
      // Es macht die Console-Ausgabe aber übersichtlicher.
      // ------------------------------------------------

      this.comprehensionTrials.sort(
        (a, b) => a - b
      )


      console.log(
        '=========================================='
      )

      console.log(
        'COMPREHENSION TRIALS'
      )

      console.log(
        '=========================================='
      )

      console.log(
        'Ausgewählte globale Indizes:',
        this.comprehensionTrials
      )

      console.log(
        'Anzahl:',
        this.comprehensionTrials.length
      )


      // ==================================================
      // IN ZWEI BLÖCKE TEILEN
      // ==================================================

      const half =
        Math.ceil(
          stimuli.length / 2
        )


      this.block1 =
        stimuli.slice(
          0,
          half
        )


      this.block2 =
        stimuli.slice(
          half
        )


      console.log(
        'BLOCKS'
      )

      console.log(
        'Block 1:',
        this.block1
      )

      console.log(
        'Block 2:',
        this.block2
      )

      console.log(
        'Block 1 Länge:',
        this.block1.length
      )

      console.log(
        'Block 2 Länge:',
        this.block2.length
      )


      // ==================================================
      // EXPERIMENT STARTEN
      // ==================================================

      this.page =
        'block1'

    },


    // ==================================================
    // ARRAY RANDOMISIEREN
    // ==================================================

    shuffle(array) {

      for (
        let i = array.length - 1;
        i > 0;
        i--
      ) {

        const j =

          Math.floor(
            Math.random() *
            (i + 1)
          )


        ;[array[i], array[j]] =

          [array[j], array[i]]

      }


      return array

    },


    // ==================================================
    // ZEIT FORMATIEREN
    // ==================================================

    formatDuration(ms) {

      const totalSeconds =
        Math.floor(
          ms / 1000
        )


      const hours =
        Math.floor(
          totalSeconds / 3600
        )


      const minutes =
        Math.floor(
          (totalSeconds % 3600) / 60
        )


      const seconds =
        totalSeconds % 60


      return [

        String(hours)
          .padStart(2, '0'),

        String(minutes)
          .padStart(2, '0'),

        String(seconds)
          .padStart(2, '0')

      ].join(':')

    },


    // ==================================================
    // BLOCK 1 BEENDET
    // ==================================================

    finishBlock1(blockResponses) {

      console.log(
        'BLOCK 1 BEENDET'
      )


      console.log(
        'Ergebnisse Block 1:',
        blockResponses
      )


      // ------------------------------------------------
      // Ergebnisse hinzufügen
      // ------------------------------------------------

      this.responses.push(
        ...blockResponses
      )


      // ------------------------------------------------
      // Pause
      // ------------------------------------------------

      this.page =
        'break'

    },


    // ==================================================
    // BLOCK 2 STARTEN
    // ==================================================

    startBlock2() {

      console.log(
        'BLOCK 2 STARTET'
      )


      this.page =
        'block2'

    },


    // ==================================================
    // GESAMTES EXPERIMENT BEENDET
    // ==================================================

    finishExperiment(blockResponses) {

      console.log(
        'BLOCK 2 BEENDET'
      )


      console.log(
        'Ergebnisse Block 2:',
        blockResponses
      )


      // ------------------------------------------------
      // Ergebnisse hinzufügen
      // ------------------------------------------------

      this.responses.push(
        ...blockResponses
      )


      console.log(
        'ALLE EXPERIMENTDATEN:',
        this.responses
      )


      // ------------------------------------------------
      // Gesamtdauer
      // ------------------------------------------------

      const durationMs =

        Date.now() -
        this.experimentStartTime


      this.experimentDuration =
        this.formatDuration(
          durationMs
        )


      // ------------------------------------------------
      // Demographics
      // ------------------------------------------------

      this.page =
        'demographics'

    },


    // ==================================================
    // DEMOGRAPHICS SPEICHERN
    // ==================================================

    saveDemographics(data) {

      console.log(
        '=========================================='
      )

      console.log(
        'SAVE DEMOGRAPHICS'
      )

      console.log(
        '=========================================='
      )


      console.log(
        'Anzahl Responses:',
        this.responses.length
      )


      this.demographics =
        data


      // ==================================================
      // CSV HEADER
      // ==================================================

      const header = [
        'participantID',
        'item',
        'list',
        'condition',
        'statement',
        'denial',
        'rating',
        'reactionTimeMs',
        'reactionTime',
        'question',
        'answer_A',
        'answer_B',
        'comprehensionAnswer',
        'comprehensionCorrect',
        'comprehensionReactionTimeMs',
        'comprehensionReactionTime',
        'age',
        'gender',
        'genderSelfDescription',
        'nativeLanguage',
        'experimentDuration'

      ]


      // ==================================================
      // CSV ROWS
      // ==================================================

      const rows =

        this.responses.map(
          r => [
            r.participantID,
            r.item,
            r.list,
            r.condition,
            r.statement,
            r.denial,
            r.rating,
            r.reactionTimeMs,
            r.reactionTime,
            r.question,
            r.answer_A,
            r.answer_B,
            r.comprehensionAnswer,
            r.comprehensionCorrect,
            r.comprehensionReactionTimeMs,
            r.comprehensionReactionTime,
            this.demographics.age,
            this.demographics.gender,
            this.demographics.genderSelfDescription,
            this.demographics.nativeLanguage,
            this.experimentDuration

          ]
        )


      // ==================================================
      // CSV ESCAPE
      // ==================================================

      function csvEscape(value) {

        const text =
          String(
            value ?? ''
          )


        return (

          '"' +

          text.replace(
            /"/g,
            '""'
          ) +

          '"'

        )

      }


      // ==================================================
      // CSV ERSTELLEN
      // ==================================================

      const csv = [

        header
          .map(csvEscape)
          .join(','),

        ...rows.map(

          row =>
            row
              .map(csvEscape)
              .join(',')

        )

      ].join('\n')


      // ==================================================
      // CSV DOWNLOAD
      // ==================================================

      const blob =
        new Blob(
          [csv],
          {
            type:
              'text/csv;charset=utf-8;'
          }
        )


      const url =
        URL.createObjectURL(
          blob
        )


      const a =
        document.createElement(
          'a'
        )


      a.href =
        url


      a.download =
        'responses.csv'


      a.click()


      URL.revokeObjectURL(
        url
      )


      // ==================================================
      // END
      // ==================================================

      this.page =
        'end'

    }

  }

}

</script>