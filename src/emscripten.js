// Radio Equinoxe (23/11/2026) : Atari 520ST+ (ST, 1 Mio), pas de disque dur.
// Affichage nu (sans barre d'état ni voyant incrusté) : la page Captain Blood
// dessine elle-même le moniteur et les voyants autour.
// AUCUNE disquette dans l'émulateur : la page parente envoie au démarrage les
// disquettes importées par le visiteur (voir emscripten_shell.html) ; elles
// sont ajoutées à ces arguments (--disk-a, --auto) avant le lancement.
Module['arguments']=[
  '--desktop','false',
  '--machine','st',
  '--memsize','1',
  '--statusbar','false',
  '--drive-led','false',
  '--borders','true'];
