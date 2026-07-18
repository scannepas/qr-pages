// ============================================================
//  Carte-message d'anniversaire – Format carte de crédit
//  85 × 55 × 2 mm — coins arrondis — texte en relief
// ============================================================

// ── Dimensions de la carte ───────────────────────────────────
longueur      = 85;    // mm – longueur
largeur       = 55;    // mm – largeur
epaisseur     = 2;     // mm – épaisseur de la base
rayon_coin    = 3.5;   // mm – rayon d'arrondi des 4 coins

// ── Relief du texte ──────────────────────────────────────────
hauteur_relief = 1.2;  // mm – épaisseur du texte au-dessus de la base
                       //      facilite le changement de filament en cours d'impression

// ── Police ───────────────────────────────────────────────────
police = "Liberation Sans:style=Bold";

// ── Texte – ligne 1 ──────────────────────────────────────────
ligne1   = "JOYEUX ANNIVERSAIRE";
taille1  = 5;      // mm  – réduire si le texte dépasse les bords
pos_y1   = 10;     // mm  – position Y depuis le centre (vers le haut)

// ── Texte – ligne 2 ──────────────────────────────────────────
// L'émoji 🪂 n'est pas rendu par OpenSCAD ; remplacé par "(PARA)"
// Vous pouvez écrire "A NOUS DEUX ! 🪂" dans un slicer qui le supporte
ligne2   = "A NOUS DEUX ! (PARA)";
taille2  = 4.2;    // mm  – légèrement plus petit pour tenir sur la carte
pos_y2   = -5;     // mm  – position Y depuis le centre (vers le bas)

// ── Séparateur central (fine ligne en relief) ────────────────
avec_separateur = true;   // passer à false pour l'enlever
sep_largeur     = 60;     // mm
sep_hauteur     = 0.6;    // mm
sep_epaisseur   = 0.4;    // mm (fin trait)

// Tolérance
eps = 0.01;

// ============================================================
//  Module : base rectangulaire à coins arrondis
//  Technique : hull() sur 4 cylindres positionnés aux coins
// ============================================================
module carte_arrondie(l, w, h, r) {
    r_eff = min(r, l/2 - eps, w/2 - eps);   // sécurité : rayon max physique
    hull() {
        translate([ l/2 - r_eff,  w/2 - r_eff, 0])
            cylinder(r = r_eff, h = h, $fn = 48);
        translate([-l/2 + r_eff,  w/2 - r_eff, 0])
            cylinder(r = r_eff, h = h, $fn = 48);
        translate([ l/2 - r_eff, -w/2 + r_eff, 0])
            cylinder(r = r_eff, h = h, $fn = 48);
        translate([-l/2 + r_eff, -w/2 + r_eff, 0])
            cylinder(r = r_eff, h = h, $fn = 48);
    }
}

// ============================================================
//  Module : texte en relief (extrusion positive sur la base)
// ============================================================
module texte_relief(contenu, taille, pos_y, relief) {
    translate([0, pos_y, epaisseur])
        linear_extrude(height = relief)
            text(
                contenu,
                size   = taille,
                font   = police,
                halign = "center",
                valign = "center"
            );
}

// ============================================================
//  Assemblage final
// ============================================================
union() {

    // ── Base de la carte ──────────────────────────────────────
    carte_arrondie(longueur, largeur, epaisseur, rayon_coin);

    // ── Ligne 1 : "JOYEUX ANNIVERSAIRE" ──────────────────────
    texte_relief(ligne1, taille1, pos_y1, hauteur_relief);

    // ── Ligne 2 : "A NOUS DEUX ! (PARA)" ─────────────────────
    texte_relief(ligne2, taille2, pos_y2, hauteur_relief);

    // ── Séparateur horizontal central (optionnel) ─────────────
    if (avec_separateur)
        translate([0, 2, epaisseur])
            cube([sep_largeur, sep_epaisseur, sep_hauteur], center = true);
}
