# App.vue

<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

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
      :comprehensionTrials="comprehensionTrialsBlock1"
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
      :comprehensionTrials="comprehensionTrialsBlock2"
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
      comprehensionTrialsBlock1: [],
      comprehensionTrialsBlock2: [],
      responses: [],
      selectedList: '',
      totalTrials: 0,
      participantID: '',
      experimentStartTime: null,
      experimentDuration: '',

      // ==================================================
      // COMPREHENSION TRIALS
      //
      //Global indices of trials with comprehension question are saved
      //
      // Example:
      //
      // [1, 4, 7]
      //
      // bedeutet:
      //
      // Trial 1 -> Question
      // Trial 4 -> Question
      // Trial 7 -> Question
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
      // CREATE TWO BLOCKS
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

      // =================================================
      // PICK COMPRHENSION TRIAL PER BLOCK
      // =================================================

      // --------------BLOCK 1----------------------------

      const numberCQBlock1 =
        Math.max(
          1,
          Math.round(
            this.block1.length / 3
          )
        )

      const block1Indices =
        this.block1.map(
          (item, index) => index
        )

      const shuffledBlock1Indices =
        this.shuffle(
          [...block1Indices]
        )

      this.comprehensionTrialsBlock1 =
        shuffledBlock1Indices
          .slice(
            0,
            numberCQBlock1
          )

      //-------------BLOCK 2-------------------------------

      const numberCQBlock2 =
      Math.max(
        1,
        Math.round(
          this.block2.length / 3
        )
      )

      const block2Indices =
        this.block2.map(
          (item, index) => index
        )

      const shuffledBlock2Indices =
        this.shuffle(
          [...block2Indices]
        )

      this.comprehensionTrialsBlock2 =
        shuffledBlock2Indices
          .slice(
            0,
            numberCQBlock2
          )

      //==================================================
      // DEBUGGING ITEM PICK PER BLOCK
      //===================================================

      console.log(
        'COMPREHENSION TRIALS'
      )

      console.log(
        'Block 1 Indizes:',
        this.comprehensionTrialsBlock1
      )

      console.log(
        'Anzahl Block 1:',
        this.comprehensionTrialsBlock1.length
      )

      console.log(
        'Block 2 Indizes:',
        this.comprehensionTrialsBlock2
      )

      console.log(
        'Anzahl Block 2:',
        this.comprehensionTrialsBlock2.length
      )

      // ==================================================
      // START EXPERIMENT
      // ==================================================

      this.page =
        'block1'

    },

    // ==================================================
    // RANDOMISE ARRAY
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
    // FORMAT TIME
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
    // BLOCK 1 END
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
      // ADD RESULTS
      // ------------------------------------------------

      this.responses.push(
        ...blockResponses
      )

      // ------------------------------------------------
      // BREAK
      // ------------------------------------------------

      this.page =
        'break'

    },

    // ==================================================
    // BLOCK 2 START
    // ==================================================

    startBlock2() {

      console.log(
        'BLOCK 2 STARTET'
      )

      this.page =
        'block2'

    },


    // ==================================================
    // FULL EXPERIMENT END
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
      // Add results
      // ------------------------------------------------

      this.responses.push(
        ...blockResponses
      )

      console.log(
        'ALLE EXPERIMENTDATEN:',
        this.responses
      )

      // ------------------------------------------------
      // Time of whole experiment
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
    // DEMOGRAPHICS SAVE
    // ==================================================

    saveDemographics(data) {

      console.log(
        'SAVE DEMOGRAPHICS'
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
        'correct_answer',
        'comprehensionAnswer',
        'comprehensionCorrect',
        'comprehensionReactionTimeMs',
        'comprehensionReactionTime',
        'federalState',
        'dialectChoice',
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
            r.correct_answer,
            r.comprehensionAnswer,
            r.comprehensionCorrect,
            r.comprehensionReactionTimeMs,
            r.comprehensionReactionTime,
            this.demographics.dialectChoice || "NA",
            this.demographics.federalState || "NA",
            this.demographics.age || "NA",
            this.demographics.gender || "NA",
            this.demographics.genderSelfDescription || "NA",
            this.demographics.nativeLanguage || "NA",
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
      // CSV CREATE
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