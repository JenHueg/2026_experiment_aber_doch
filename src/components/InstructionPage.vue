<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com
OpenAI.(2026). ChatGPT (GPT -6). [Large language model]. https.://chatgpt.com 

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

<template>
  <div class="page">
    <h1>Instruktionen</h1>

    <p>
      Im Folgenden werden Sie Äußerungen von zwei Sprecherinnen oder Sprechern sehen. Lesen Sie sich die Äußerungen aufmerksam durch. 
    </p>

    <p>
    Ihre Aufgabe ist es, die Äußerungen dahingehend zu bewerten, wie gut oder schlecht Sie diese finden. Sie bekommen dafür eine Skala angezeigt. Dabei gibt es folgende Werte: 5 (sehr gut) - 4 - 3 - 2 - 1 (sehr schlecht). Sie müssen die entsprechende Zahl auf der Skala anklicken (entweder mit einer Maus oder mit Hilfe eines Touchpads, wenn Sie einen Laptop verwenden). Antworten Sie bitte spontan und ohne lange nachzudenken. Sie haben insgesamt 10 Sekunden Zeit, um eine Antwort anzuklicken. Haben Sie eine Antwort angeklickt, drücken Sie bitte auf die „Weiter“-Schaltfläche, um zum nächsten Durchgang zu gelangen. Sollten die 10 Sekunden ablaufen, ohne dass Sie eine Antwort angeklickt haben, wird Ihnen automatisch der nächste Durchgang präsentiert. 
    </p>

    <p>
    Zudem enthalten einige Durchgänge eine Verständnisfrage, um die Aufmerksamkeit zu überprüfen. Bitte beantworten Sie diese Verständnisfragen auf Basis des zuvor gelesenen Inhalts der beiden Äußerungen. Auch hierfür haben sie jeweils 10 Sekunden Zeit. 
    </p>

    <p>
    Das genaue Vorgehen wird Ihnen zu Beginn anhand einiger Übungsbeispiele verdeutlicht. Hier erhalten Sie bei den Verständnisfragen auch eine Rückmeldung, ob Ihre Antwort richtig oder falsch war. Während des richtigen Experiments fällt diese Rückmeldung weg. 
    </p>

    <p>
    Das Experiment dauert ca. 15 Minuten. 
    </p>

    <p> 
      Bitte klicken Sie auf den Button "Übungsblock starten". Sie erhalten eine Benachrichtigung, sobald das richtige Experiment beginnt.
    </p>

    <button @click="$emit('next')">
      Übungsblock starten
    </button>
  </div>
</template>

<style scoped>
.page {
  max-width: 850px;
  margin: 30px auto;
  padding: 0 25px;
  text-align: left;
  font-family: Arial, sans-serif;
  font-size: 15px;
  line-height: 1.5;
}

button {
  margin-top: 20px;
  padding: 12px 24px;
  font-size: 18px;
}
</style>