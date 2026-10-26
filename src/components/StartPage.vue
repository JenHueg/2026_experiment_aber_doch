<!-- ====================================
TRANSPARENCY
This code was developed using the help of AI. The model used: 
OpenAI.(2026). ChatGPT (GPT -5.6 Luna). [Large language model]. https.://chatgpt.com
OpenAI.(2026). ChatGPT (GPT -6). [Large language model]. https.://chatgpt.com 

PLEASE ADD HERE OTHER MODELS THAT ARE USED WHEN DEVELPING THIS CODE FURTHER: 

    ======================================== -->

<template>
  <div class="page">
    <h1>Willkommen zu unserer Studie zum Satzverständnis!</h1>

    <p>
      Wir danken Ihnen für Ihr Interesse an dieser Studie. Wir untersuchen mit dieser Studie, wie verschiedene Sätze verstanden werden. Genauere Informationen zum Forschungszweck erhalten Sie nach Ihrer Teilnahme auf Anfrage. Dieses Schreiben dient dazu, Sie über das Ziel der Studie sowie über das Vorgehen in dem Forschungsprojekt zu informieren. Bitte lesen Sie sich den Text aufmerksam durch.
    </p>

    <p>
    Im Folgenden werden Sie Äußerungen von zwei Sprecherinnen oder Sprechern sehen. Lesen Sie sich die Äußerungen aufmerksam durch. Ihre Aufgabe ist es, die Äußerungen dahingehend zu bewerten, wie gut oder schlecht Sie diese finden. Sie bekommen dafür eine Skala angezeigt. Dabei gibt es folgende Werte: 5 (sehr gut) - 4 - 3 - 2 - 1 (sehr schlecht). Sie müssen die entsprechende Zahl auf der Skala anklicken (entweder mit einer Maus oder mit Hilfe eines Touchpads, wenn Sie einen Laptop verwenden). Antworten Sie bitte spontan und ohne lange nachzudenken. Sie haben insgesamt 10 Sekunden Zeit, um eine Antwort anzuklicken. Haben Sie eine Antwort angeklickt, drücken Sie bitte auf die „Weiter“-Schaltfläche, um zum nächsten Durchgang zu gelangen. Sollten die 10 Sekunden ablaufen, ohne dass Sie eine Antwort angeklickt haben, wird Ihnen automatisch der nächste Durchgang präsentiert. Zudem enthalten einige Durchgänge eine Verständnisfrage, um die Aufmerksamkeit zu überprüfen. Bitte beantworten Sie diese Verständnisfragen auf Basis des zuvor gelesenen Inhalts der beiden Äußerungen. Das genaue Vorgehen wird Ihnen zu Beginn anhand einiger Übungsbeispiele verdeutlicht. Das Experiment dauert ca. 15 Minuten. 
    </p>

    <p>
      Im Rahmen der Studie werden, abgesehen von freiwilligen Angaben am Ende, keine personenbezogenen Daten erhoben oder verarbeitet. Alle Daten werden anonym auf einem Server der Universität Tübingen abgespeichert. IP-Adressen, MAC-Adressen oder Ortungs-Daten sind im Rahmen der Studien nicht relevant und werden demnach nicht erhoben. Nach Beenden des Experiments wird Ihr Datensatz anonym gespeichert und kann dann nicht mehr zugeordnet oder gezielt gelöscht werden. Die Projektmitarbeiterinnen und Projektmitarbeiter unterliegen der Schweigepflicht bzw. dem Datengeheimnis. Die anonymen Daten werden mindestens 10 Jahre gespeichert und können für zukünftige Forschungsvorhaben genutzt und weiterverarbeitet werden. Die erhobenen Daten werden in anonymer Form in einem Forschungsdatenrepositorium veröffentlicht. Ihre Identität wird hier nicht bekannt. Die Forschungsergebnisse aus der Studie werden in anonymer Form in Fachzeitschriften oder in wissenschaftlichen Datenbanken veröffentlicht. Bei der Veröffentlichung der Forschungsergebnisse wird Ihre Identität nicht bekannt. Die Studienleiterin (Prof. Dr. Britta Stolterfoht) ist für die Datenverarbeitung und die Einhaltung der gesetzlichen Datenschutzbestimmungen verantwortlich und bei Fragen unter der E-Mail-Adresse britta.stolterfoht@uni-tuebingen.de zu erreichen. Bei weiteren Anliegen können Sie sich an den Datenschutzbeauftragten der Universität Tübingen (Geschwister-Scholl-Platz, 72074 Tübingen, E-Mail: datenschutz@uni-tuebingen.de, Telefon: +49 70 71 29-76480) wenden. Für die Erhebung, Speicherung, Nutzung und Weitergabe Ihrer Daten ist Ihre ausdrückliche Zustimmung durch Anklicken der Punkte in der Einwilligungserklärung zum Datenschutz erforderlich. Diese finden Sie im nächsten Abschnitt. 
      Am Ende des Experiments werden Sie wieder automatisch auf die Plattform Prolific geleitet, um die Teilnahme zu bestätigen. Klicken Sie bitte im entsprechenden Fenster auf „OK“, um zu Prolific weitergeleitet zu werden. 
      Sie können das Experiment, bis Sie den letzten Button „Experiment beenden“ betätigen, jederzeit und ohne Angabe von Gründen abbrechen, ohne dass Ihnen daraus Nachteile entstehen. Für den Abbruch drücken Sie bitte die Escape-Taste (ESC) auf Ihrer Tastatur. Ihre Daten werden dann nicht gespeichert. Sie werden nach dem Beenden des Experiments auch hier automatisch zu Prolific weitergeleitet. Sie haben dann trotzdem für die bis dahin vergangene Zeit Anspruch auf eine entsprechende Kompensation. Falls Sie frühzeitig abbrechen sollten, haben Sie folglich die Möglichkeit, uns zu kontaktieren und ein Debriefing mit einer Erklärung unserer Forschungsfragen und Methoden zu erhalten. In diesem Fall kontaktieren Sie bitte Ihre Kontaktperson oder die Studienleiterin (Prof. Dr. Britta Stolterfoht, britta.stolterfoht@uni-tuebingen.de).
    </p>

    <p>
      Mit dem Drücken des Weiter-Buttons versichern Sie, dass Sie die oben beschriebenen Teilnahmeinformationen verstanden haben und mit den genannten Teilnahmebedingungen einverstanden sind.

    </p>

    <button @click="$emit('next')">
      Weiter
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