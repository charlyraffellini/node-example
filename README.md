[![Build Status](https://travis-ci.org/charlyraffellini/node-example.svg)](https://travis-ci.org/charlyraffellini/node-example)
[![Code Climate](https://codeclimate.com/github/charlyraffellini/node-example/badges/gpa.svg)](https://codeclimate.com/github/charlyraffellini/node-example)
[![Test Coverage](https://codeclimate.com/github/charlyraffellini/node-example/badges/coverage.svg)](https://codeclimate.com/github/charlyraffellini/node-example/coverage)

Il presente repository è utilizzato per la prova di programmazione da parte dei candidati per la posizione aperta di "sviluppatore full stack" presso Kopjra Srl.

Il tempo complessivo stimato per completare la prova è di circa 4 ore.

# Direttive comuni e modalità di consegna

E' stata fornita una applicazione dummy in Node.js su Express 4, senza front-end, che risponde esclusivamente alla chiamata `GET /hello`. Si prega di estendere l'applicazione, seguendo le direttive indicate nell'esercizio specifico. La soluzione dovrà effettuare anche la validazione dell'input (sia lato front-end che back-end) e contenere le classi di test. Non è prevista una deadline per la consegna.

1. Effettuare un fork del presente repository;
1. Eseguire l'esercizio seguendo la descrizione e le consegne indicate;
1. Se si hanno delle domande, si prega di aprire un'issue sul repository stesso;
1. Al termine delle modifiche effettuare una Pull Request.

# Descrizione generale

Lo scopo della prova è quello di creare una semplice applicazione che permetta la compravendita di un solo strumento finanziario.

Tutti gli utenti possono effettuare operazioni di compravendita (previa verifica delle loro disponibilità liquide per gli acquisti ed il possesso dello strumento per le relative vendite; tali disponibilità dovranno essere opportunamente scalate dal portafoglio dell'utente prima dell'inserimento della proposta).
Non sono permesse operazioni di vendita allo scoperto.

Elemento cardine dell'applicazione è il libro (book) contenente le proposte di acquisto e vendita con relativo prezzo e volume. Si visiti la seguente pagina di Borsa Italiana per ulteriori informazioni: http://www.borsaitaliana.it/notizie/sotto-la-lente/il-book.htm

Si gestiscano ESCLUSIVAMENTE le proposte con limite di prezzo.

Le proposte inserite saranno eseguite immediatamente se sul lato opposto del mercato sono presenti una o più proposte di negoziazione ad un prezzo non peggiore rispetto a quello indicato come limite.
In tal caso, le proposte saranno eseguite SEMPRE anche se solo parzialmente, cioè se le quantità disponibili entro il prezzo limite non soddisfano pienamente la proposta.
La proposta relativa alla quantità residua sarà inserita opportunamente nel Book al prezzo specificato.

## Ipotesi semplificative

1. Sarà utilizzata una sola valuta fittizia divisibile in millesimi;
1. Come già indicato, esiste un unico strumento finanziario da scambiare sulla piattaforma;
1. Non esiste il concetto di utente con privilegi di amministratore: tutti gli utenti sono "unprivileged", ognuno dei quali ha accesso esclusivamente alle proprie risorse;
1. Non è prevista la pagina di registrazione ma solo quella di login;
1. L'inserimento di nuovi utenti o la modifica/rimozione degli utenti già esistenti (ivi incluso il caricamento del portafoglio iniziale per ogni utente) avverrà eventualmente a mano intervenendo direttamente sul data storage.
1. Ovviamente il wallet relativo agli utenti andrà modificato in maniera opportuna in seguito ad una transazione avvenuta con successo e all'inserimento di una nuova proposta;
1. Non è necessario raggruppare le proposte aventi lo stesso prezzo sul book.

# Direttive specifiche per il front-end

Il front-end dovrà essere una Single Page Application sviluppata in React (preferibilmente con metodologia Flux) che utilizzi le API RESTful messe a disposizione dal back-end. Si consiglia l'utilizzo di Bootstrap per il templating di base.

La UI dovrà semplicemente permettere l'utilizzo delle funzionalità descritte in precedenza. La valutazione della UX non è un obiettivo specifico della prova.

# Direttive specifiche per il back-end

Il back-end dovrà esporre delle API RESTful e dovrà essere sviluppato utilizzando in JavaScript, con Node.js su framework Express 4. Le interazioni sul database sottostante dovranno essere simulate utilizzando i mock object forniti con l'esercizio.

Tutte le chiamate sulle API RESTful del back-end devono accettare un contenuto di tipo "application/json" e *devono* rispondere con un contenuto dello stesso tipo.

Eventualmente i contenuti statici potranno essere serviti direttamente da Express ma è assolutamente vietato il pre-rendering dell'HTML da parte del back-end.

Si scelga il modello di autenticazione preferito.
