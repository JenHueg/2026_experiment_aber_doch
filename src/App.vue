# App.vue

<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The models used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com 
OpenAI.(2026). ChatGPT (GPT -6). [Large language model]. https.://chatgpt.com 

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

<template>

  <div>

    <!-- ==================================================
         START
         ================================================== -->
    <StartPage
      v-if="page === 'start'"
      @next="showConsentPage"
    />

    <!-- ==================================================
        CONSENT PAGE
        =================================================== -->

    <ConsentPage
      v-if="page === 'consent'"
      @next="continueAfterConsent"
    />

    <!-- ==================================================
         INSTRUCTIONS
         ================================================== -->

    <InstructionPage
      v-if="page === 'instructions'"
      @next="startPractice"
    />

    <!-- ==================================================
        PRACTICE 
        =================================================== -->

    <TrialPage
      key="practice"
      v-if="page === 'practice'"
      :stimuli="practiceItems"
      :totalTrials="practiceItems.length"
      :startIndex="0"
      :participantID="participantID"
      :comprehensionTrials="comprehensionTrialsPractice"
      :showComprehensionFeedback="true"
      @finished="finishPractice"
    />

    <!-- ===================================================
      SHOWING THAT MAIN EXPERIMENT IS STARTING
      =================================================== -->

      <ExperimentIntroPage
      v-if="page === 'experimentIntro'"
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
import magpieConfig from './magpie.config.js'
import StartPage from './components/StartPage.vue'
import ConsentPage from './components/ConsentPage.vue'
import InstructionPage from './components/InstructionPage.vue'
import ExperimentIntroPage from './components/ExperimentIntroPage.vue'
import TrialPage from './components/TrialPage.vue'
import BreakPage from './components/BreakPage.vue'
import DemographicsPage from './components/DemographicsPage.vue'
import EndPage from './components/EndPage.vue'

export default {

  components: {
    StartPage,
    ConsentPage,
    InstructionPage,
    ExperimentIntroPage,
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
      practiceItems: [],
      comprehensionTrialsPractice: [2,3,5],
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

  // ===================================
  // PRESSING ESCAPE TO CANCEL THE EXPERIMENT
  // ===================================

  mounted() {
  window.addEventListener('keydown', this.handleEscapeKey)
  },

  beforeDestroy() {
  window.removeEventListener('keydown', this.handleEscapeKey)
  },

  // ==================================================
  // METHODS
  // ==================================================

  methods: {

    //======================================
    // FOR CONSENT PAGE 
    //======================================

    showConsentPage() {
    this.page = 'consent'
    },

    continueAfterConsent() {
    this.page = 'instructions'
    },

    // =============================================
    // STARTING PRACTICE TRIAL 
    // ============================================= 

    async startPractice() {
      try {
        const response = await fetch('./practice_stimuli.csv')

        if (!response.ok) {
          throw new Error('Übungs-CSV konnte nicht geladen werden.')
        }

        const csvText = await response.text()

        const parsed = Papa.parse(csvText, {
          header: true,
          skipEmptyLines: true
        })

        if (parsed.errors.length > 0) {
          console.error('Fehler beim Einlesen:', parsed.errors)
        }

        this.practiceItems = parsed.data.filter(
          item =>
            item.item &&
            item.statement &&
            item.denial
        )

        if (this.practiceItems.length !== 6) {
          throw new Error(
            `Es wurden ${this.practiceItems.length} statt 6 Übungsitems geladen.`
          )
        }

        this.page = 'practice'

      } catch (error) {
        console.error('Fehler beim Laden der Übungsitems:', error)

        alert(
          'Die Übungsitems konnten nicht geladen werden. Bitte laden Sie die Seite neu.'
        )
      }
    },

    // ============================================
    // GO TO MAIN EXPERIMENT AFTER PRACTICE 
    // ===========================================

    finishPractice() {
    this.page = 'experimentIntro'
    },

    // =============================================
    // RETURN TO PROLIFIC AFTER PRESSING ESCAPE
    // =============================================

    handleEscapeKey(event) {
      if (event.key !== 'Escape') {
      return
      }
      event.preventDefault()
      const confirmAbort = window.confirm(
      'Möchtest du das Experiment wirklich abbrechen? Nach dem Klick auf "OK" wirst Du automatisch zu Prolific geleitet.'
      )
      if (confirmAbort) {
      window.location.replace(
        'URL FOR PROLIFIC AFTER PRESSING ESC'
      )
      }
    },

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
        await fetch('./stimuli.csv')

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

    async saveDemographics(data) {

      console.log(
        'SAVE DEMOGRAPHICS'
      )

      console.log(
        'Anzahl Responses:',
        this.responses.length
      )

       console.log('SCHRITT 1: Nach den ersten Logs')

      this.demographics =
        data

    // =====================================================
    // ADD TRIAL DATA TO MAGPIE 
    // =====================================================

    this.responses.forEach(
      response => {
        this.$magpie.addTrialData(
          response
        )
      }
    )

    // ====================================================
    // ADD DEMOGRAPHICS AND EXPERIMENT DATA
    // =====================================================

    this.$magpie.addExpData({

      participantID:
        this.participantID,

      selectedList:
        this.selectedList,

      dialectChoice:
        this.demographics.dialectChoice || 'NA',

      federalState:
        this.demographics.federalState || 'NA',

      age:
        this.demographics.age || 'NA',

      gender:
        this.demographics.gender || 'NA',

      genderSelfDescription:
        this.demographics.genderSelfDescription || 'NA',

      nativeLanguage:
        this.demographics.nativeLanguage || 'NA',

      experimentDuration:
        this.experimentDuration

    })

    // ===================================================
    // SEND DATA TO MAGPIE SERVER 
    // ===================================================

    console.log(
      'MAGPIE-METHODEN:',
      Object.keys(this.$magpie)
    )

    console.log(
      'SUBMIT VERFÜGBAR:',
      typeof this.$magpie.submit
    )
    
    try {
      console.log('VOR MAGPIE SUBMIT')

        console.log(
  'SUBMISSION URL TYP:',
  typeof this.$magpie.submissionUrl
)

console.log(
  'SUBMISSION URL WERT:',
  String(this.$magpie.submissionUrl)
)

console.log(
  'SOCKET STATE TYP:',
  typeof this.$magpie.socket?.state
)

console.log(
  'SOCKET STATE WERT:',
  String(this.$magpie.socket?.state)
)

      const submitResult = this.$magpie.submit()

      console.log('SUBMIT RÜCKGABE:', submitResult)
      console.log(
        'PROMISE ERKANNT:',
        typeof submitResult.then === 'function'
      )

      submitResult
        .then(() => {
          console.log('MAGPIE SUBMIT ERFOLGREICH')
          this.page = 'end'
        })
        .catch(error => {
          console.error('MAGPIE SUBMIT FEHLGESCHLAGEN:', error)
        })

    } catch (error) {
      console.error('FEHLER VOR ODER BEIM SUBMIT:', error)
    }



      // ==================================================
      // CSV HEADER - as comment because only needed for creating csv locally
      // ==================================================

    //  const header = [
    //    'participantID',
    //    'item',
    //    'list',
    //    'condition',
    //    'statement',
    //    'denial',
    //    'rating',
    //    'reactionTimeMs',
    //    'reactionTime',
    //    'question',
    //    'answer_A',
    //    'answer_B',
    //    'correct_answer',
    //    'comprehensionAnswer',
    //    'comprehensionCorrect',
    //    'comprehensionReactionTimeMs',
    //    'comprehensionReactionTime',
    //    'dialectChoice',
    //    'federalState',
    //    'age',
    //    'gender',
    //    'genderSelfDescription',
    //    'nativeLanguage',
    //    'experimentDuration'

    //  ]

      // ==================================================
      // CSV ROWS - as comment because only needed to create csv locally
      // ==================================================

    //  const rows =

    //    this.responses.map(
    //      r => [
    //        r.participantID,
    //        r.item,
    //        r.list,
    //        r.condition,
    //        r.statement,
    //        r.denial,
    //        r.rating,
    //        r.reactionTimeMs,
    //        r.reactionTime,
    //        r.question,
    //        r.answer_A,
    //        r.answer_B,
    //        r.correct_answer,
    //        r.comprehensionAnswer,
    //        r.comprehensionCorrect,
    //        r.comprehensionReactionTimeMs,
    //        r.comprehensionReactionTime,
    //        this.demographics.dialectChoice || "NA",
    //        this.demographics.federalState || "NA",
    //        this.demographics.age || "NA",
    //        this.demographics.gender || "NA",
    //        this.demographics.genderSelfDescription || "NA",
    //        this.demographics.nativeLanguage || "NA",
    //        this.experimentDuration

    //      ]
    //    )

      // ==================================================
      // CSV ESCAPE - as comment because only needed to create csv locally
      // ==================================================

    //  function csvEscape(value) {

    //    const text =
    //      String(
    //        value ?? ''
    //      )

    //    return (

    //      '"' +

    //      text.replace(
    //        /"/g,
    //        '""'
    //      ) +

    //      '"'

    //    )

    //  }

      // ==================================================
      // CSV CREATE - as comment because only needed to create csv locally
      // ==================================================

    //  const csv = [

    //    header
    //      .map(csvEscape)
    //      .join(','),

    //    ...rows.map(

    //      row =>
    //        row
    //          .map(csvEscape)
    //          .join(',')

    //    )

    //  ].join('\n')


      // ==================================================
      // CSV DOWNLOAD LOCALLY (!!) 
      // As comment because this is only for local test, otherwise magpie serve app is used to store result
      // ==================================================

    //  const blob =
    //    new Blob(
    //      [csv],
    //     {
    //        type:
    //          'text/csv;charset=utf-8;'
    //     }
     //   )

    //  const url =
    //    URL.createObjectURL(
    //      blob
     //   )

    //  const a =
    //    document.createElement(
    //      'a'
    //    )

    //  a.href =
    //    url

    //  a.download =
    //    'responses.csv'

    //  a.click()

    //  URL.revokeObjectURL(
    //    url
    //  )

      // ==================================================
      // END
      // ==================================================

      // this.page =
      //  'end'

    }

  }

}

</script>