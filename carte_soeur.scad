// ============================================================
//  Carte "Joyeux anniversaire Ma soeur" – Format agrandi
//  160 × 115 × 3 mm base + 1.5 mm relief texte
//
//  IMPRESSION BICOLORE :
//    Couleur 1 (ex. blanc)  → couches Z = 0 à 3.0 mm (base)
//    → PAUSE filament (M600 dans le slicer à Z=3.0 mm)
//    Couleur 2 (ex. bleu, rose, rouge...)
//                           → couches Z > 3.0 mm (texte + cadre)
// ============================================================

// ── Dimensions de la carte ───────────────────────────────────
longueur      = 160;    // mm
largeur       = 115;    // mm
epaisseur     = 3;      // mm – base (couleur 1)
rayon_coin    = 7;      // mm – arrondi des coins

// ── Relief du texte et du cadre ──────────────────────────────
relief        = 1.5;    // mm – extrusion au-dessus de la base (couleur 2)

// ── Cadre décoratif intérieur ─────────────────────────────────
cadre_marge   = 4;      // mm depuis le bord de la carte
cadre_ep      = 0.8;    // mm – épaisseur du trait du cadre
cadre_relief  = 1;      // mm – hauteur du relief cadre

// ── Police ───────────────────────────────────────────────────
police        = "Liberation Sans:style=Bold";

eps = 0.01;

// ── Lignes de texte ──────────────────────────────────────────
//   Emojis non supportés par OpenSCAD → remplacements :
//   🎈 → "" (omis)   😜 → ";-)"   ❤️ → "<3"

// Titre
l1 = "Joyeux anniversaire";    t1 = 7.5;   pos_y1 =  44;
l2 = "Ma soeur !";             t2 = 6;     pos_y2 =  34;

// Séparateur 1 à Y = 27.5

// Corps
l3 = "Je t'offre un petit souvenir en avance...";  t3 = 3.5; pos_y3 =  20;
l4 = "pour etre sur que tu ne degonfles pas";       t4 = 3.5; pos_y4 =  13;
l5 = "d'ici le mois d'aout ! ;-)";                 t5 = 3.5; pos_y5 =   6;

// Séparateur 2 à Y = -1

// Ligne choc
l6 = "Prepare-toi, le grand saut approche !";       t6 = 3.5; pos_y6 =  -9;

// Séparateur 3 à Y = -16.5

// Signature
l7 = "Gros bisous";                                 t7 = 5;   pos_y7 = -24;
l8 = "JE T'AIME  <3  <3";                          t8 = 6.5; pos_y8 = -34;

// ============================================================
//  Modules
// ============================================================

// Base à coins arrondis (hull sur 4 cylindres)
module carte_arrondie(l, w, h, r) {
    r_eff = min(r, l/2 - eps, w/2 - eps);
    hull() {
        translate([ l/2-r_eff,  w/2-r_eff, 0]) cylinder(r=r_eff, h=h, $fn=48);
        translate([-l/2+r_eff,  w/2-r_eff, 0]) cylinder(r=r_eff, h=h, $fn=48);
        translate([ l/2-r_eff, -w/2+r_eff, 0]) cylinder(r=r_eff, h=h, $fn=48);
        translate([-l/2+r_eff, -w/2+r_eff, 0]) cylinder(r=r_eff, h=h, $fn=48);
    }
}

// Anneau de cadre en relief (outer - inner)
module cadre_deco(l, w, h, r, marge, ep, hcadre) {
    r_out = max(r - marge, 1);
    r_in  = max(r_out - ep, 0.5);
    translate([0, 0, h])
        difference() {
            carte_arrondie(l - 2*marge,       w - 2*marge,       hcadre,      r_out);
            carte_arrondie(l - 2*marge - 2*ep, w - 2*marge - 2*ep, hcadre+eps, r_in);
        }
}

// Texte en relief
module txt(contenu, taille, pos_y) {
    translate([0, pos_y, epaisseur])
        linear_extrude(height = relief)
            text(contenu, size=taille, font=police,
                 halign="center", valign="center");
}

// Séparateur horizontal
module sep(pos_y, lg=120) {
    translate([0, pos_y, epaisseur])
        cube([lg, 0.6, 0.8], center=true);
}

// ============================================================
//  Assemblage
// ============================================================
union() {

    // ── Couleur 1 : base plate ────────────────────────────────
    carte_arrondie(longueur, largeur, epaisseur, rayon_coin);

    // ── Couleur 2 : tout ce qui suit (texte + cadre) ─────────

    // Cadre décoratif
    cadre_deco(longueur, largeur, epaisseur, rayon_coin,
               cadre_marge, cadre_ep, cadre_relief);

    // Titre
    txt(l1, t1, pos_y1);
    txt(l2, t2, pos_y2);

    sep(27.5, 140);

    // Corps
    txt(l3, t3, pos_y3);
    txt(l4, t4, pos_y4);
    txt(l5, t5, pos_y5);

    sep(-1, 100);

    // Ligne choc
    txt(l6, t6, pos_y6);

    sep(-16.5, 140);

    // Signature
    txt(l7, t7, pos_y7);
    txt(l8, t8, pos_y8);
}
