// ============================================================
//  CARTE COMPLICE D'ANNIVERSAIRE – v2 avec motif géométrique
//  100 × 68 × 2.0 mm  |  ultra-fine  |  bicolore
//
//  IMPRESSION BICOLORE :
//    Couleur 1  →  Z = 0 à 1.2 mm   (base)
//    Couleur 2  →  Z > 1.2 mm       (motif + texte)
//    → Insérer une pause filament (M600) à Z = 1.2 mm dans le slicer
// ============================================================

// ── Dimensions ───────────────────────────────────────────────
largeur         = 100;
hauteur         = 68;
epaisseur_base  = 1.2;
rayon_coins     = 5;

// ── Relief ───────────────────────────────────────────────────
relief_motif    = 0.35;  // mm – lignes du motif (discret, couleur 2)
relief_texte    = 0.8;   // mm – texte (dominant, couleur 2)

// ── Motif géométrique : lignes diagonales à 45° ──────────────
motif_espacement = 5.0;  // mm entre chaque ligne
motif_largeur    = 0.7;  // mm – épaisseur d'une ligne

// ── Police ───────────────────────────────────────────────────
police_bold   = "Liberation Sans:style=Bold";
police_italic = "Liberation Sans:style=Italic";

$fn = 80;
eps = 0.01;

// ============================================================
//  Module : plaque à coins arrondis
// ============================================================
module plaque_arrondie(w, h, t, r) {
    linear_extrude(height = t)
        hull() {
            translate([-w/2+r, -h/2+r]) circle(r);
            translate([ w/2-r, -h/2+r]) circle(r);
            translate([-w/2+r,  h/2-r]) circle(r);
            translate([ w/2-r,  h/2-r]) circle(r);
        }
}

// ============================================================
//  Module : motif de lignes diagonales clippé sur la carte
// ============================================================
module motif_diagonal(w, h, r, espacement, lw, rel) {
    intersection() {
        // Zone de clip : silhouette de la carte
        linear_extrude(height = rel + eps)
            hull() {
                translate([-w/2+r, -h/2+r]) circle(r);
                translate([ w/2-r, -h/2+r]) circle(r);
                translate([-w/2+r,  h/2-r]) circle(r);
                translate([ w/2-r,  h/2-r]) circle(r);
            }
        // Lignes diagonales (couvrent largement la carte)
        linear_extrude(height = rel + eps)
            union() {
                for (i = [-30 : 1 : 30])
                    translate([i * espacement, 0])
                        rotate(45)
                            square([lw, 250], center = true);
            }
    }
}

// ============================================================
//  Module : texte en relief
// ============================================================
module txt(contenu, taille, pos_y, police) {
    translate([0, pos_y, epaisseur_base])
        linear_extrude(height = relief_texte)
            text(contenu, size = taille, font = police,
                 halign = "center", valign = "center");
}

// ============================================================
//  Assemblage
// ============================================================
union() {

    // ── COULEUR 1 : base plate ────────────────────────────────
    plaque_arrondie(largeur, hauteur, epaisseur_base, rayon_coins);

    // ── COULEUR 2 : motif + texte ─────────────────────────────
    translate([0, 0, epaisseur_base]) {

        // Motif diagonales
        motif_diagonal(largeur, hauteur, rayon_coins,
                       motif_espacement, motif_largeur, relief_motif);

        // Cadre intérieur fin (renforce le motif sur les bords)
        difference() {
            linear_extrude(relief_motif)
                hull() {
                    translate([-largeur/2+rayon_coins-1, -hauteur/2+rayon_coins-1]) circle(rayon_coins-1);
                    translate([ largeur/2-rayon_coins+1, -hauteur/2+rayon_coins-1]) circle(rayon_coins-1);
                    translate([-largeur/2+rayon_coins-1,  hauteur/2-rayon_coins+1]) circle(rayon_coins-1);
                    translate([ largeur/2-rayon_coins+1,  hauteur/2-rayon_coins+1]) circle(rayon_coins-1);
                }
            linear_extrude(relief_motif + eps)
                hull() {
                    translate([-largeur/2+rayon_coins+0.2, -hauteur/2+rayon_coins+0.2]) circle(rayon_coins+0.2);
                    translate([ largeur/2-rayon_coins-0.2, -hauteur/2+rayon_coins+0.2]) circle(rayon_coins+0.2);
                    translate([-largeur/2+rayon_coins+0.2,  hauteur/2-rayon_coins-0.2]) circle(rayon_coins+0.2);
                    translate([ largeur/2-rayon_coins-0.2,  hauteur/2-rayon_coins-0.2]) circle(rayon_coins+0.2);
                }
        }
    }

    // Texte (couleur 2, dominant car plus haut que le motif)
    txt("JOYEUX ANNIVERSAIRE",          5.2,  19, police_bold);
    txt("Ma petite soeur adoree,",      4.5,   9, police_italic);
    txt("Prete a decoller avec moi ?",  4.2,  -2, police_bold);
    txt("Rendez-vous en Aout 2026 !",   4.2, -11, police_bold);
    txt("Je t'aime fort.  <3",          5.0, -21, police_bold);
}
