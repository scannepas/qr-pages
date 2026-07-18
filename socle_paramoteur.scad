// ============================================================
//  Socle paramoteur – "BON VOL" (Version Corrigée)
//  Imprimable en FDM, face inférieure posée sur le plateau
// ============================================================

// ── Socle principal ──────────────────────────────────────────
diametre_socle   = 70;    // mm – diamètre du disque
hauteur_socle    = 8;     // mm – hauteur totale du socle

// ── Fente de maintien (centrée, sur le dessus) ───────────────
fente_longueur   = 25;    // mm – longueur de la fente
fente_largeur    = 3.5;   // mm – épaisseur de la fente
fente_profondeur = 5;     // mm – profondeur (ne traverse pas le socle)

// ── Texte gravé en creux ─────────────────────────────────────
texte            = "BON VOL";
texte_taille     = 7;     // mm – hauteur des caractères
texte_profondeur = 1;     // mm – profondeur de la gravure
texte_police     = "Liberation Sans:style=Bold";
// Décalage en Y : valeur négative = vers l'avant (face visible)
// La fente est centrée en [0,0] ; le texte se place devant elle
texte_decalage_y = -16;   // mm

// Tolérance pour éviter les artefacts de faces coplanaires
eps = 0.01;

// ============================================================
//  Construction
// ============================================================
difference() {

    // ── Corps : disque plat ───────────────────────────────────
    cylinder(
        h    = hauteur_socle,
        d    = diametre_socle,
        $fn  = 128
    );

    // ── Fente rectangulaire sur la face supérieure ───────────
    // center=true : le cube est centré → translate au milieu de la fente
    translate([0, 0, hauteur_socle - (fente_profondeur / 2)])
        cube(
            [fente_longueur, fente_largeur, fente_profondeur + eps],
            center = true
        );

    // ── Gravure "BON VOL" en creux (face supérieure, avant) ──
    // linear_extrude vers le bas depuis la surface : on soustrait 1 mm
    translate([0, texte_decalage_y, hauteur_socle - texte_profondeur])
        linear_extrude(height = texte_profondeur + eps)
            text(
                texte,
                size   = texte_taille,
                font   = texte_police,
                halign = "center",
                valign = "center"
            );
}
