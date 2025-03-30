//
//  LocationPickerView.swift
//  Drop
//
//  Created by Dario on 30/03/25.
//

import SwiftUI
import MapKit
import Combine

// Make CLLocationCoordinate2D conform to Equatable
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// Variables globales para las estaciones
let stations: [(name: String, coordinate: CLLocationCoordinate2D)] = [
    ("Talleres", CLLocationCoordinate2D(latitude: 25.75389, longitude: -100.36528)),
    ("San Bernabé", CLLocationCoordinate2D(latitude: 25.74833, longitude: -100.36167)),
    ("Unidad Modelo", CLLocationCoordinate2D(latitude: 25.74194, longitude: -100.35500)),
    ("Aztlán", CLLocationCoordinate2D(latitude: 25.7321485, longitude: -100.3472600)),
    ("Penitenciaría", CLLocationCoordinate2D(latitude: 25.7233152, longitude: -100.3425450)),
    ("Alfonso Reyes", CLLocationCoordinate2D(latitude: 25.71611, longitude: -100.34250)),
    ("Mitras", CLLocationCoordinate2D(latitude: 25.7059242, longitude: -100.3424003)),
    ("Simón Bolívar", CLLocationCoordinate2D(latitude: 25.6987474, longitude: -100.3431880)),
    ("Hospital", CLLocationCoordinate2D(latitude: 25.69194, longitude: -100.34417)),
    ("Edison", CLLocationCoordinate2D(latitude: 25.68694, longitude: -100.33361)),
    ("Central", CLLocationCoordinate2D(latitude: 25.68694, longitude: -100.32444)),
    ("Cuauhtémoc", CLLocationCoordinate2D(latitude: 25.68611, longitude: -100.31694)),
    ("Del Golfo", CLLocationCoordinate2D(latitude: 25.68512, longitude: -100.30663)),
    ("Félix U. Gómez", CLLocationCoordinate2D(latitude: 25.68389, longitude: -100.29667)),
    ("Parque Fundidora", CLLocationCoordinate2D(latitude: 25.68361, longitude: -100.28806)),
    ("Y Griega", CLLocationCoordinate2D(latitude: 25.6832309, longitude: -100.2794460)),
    ("Eloy Cavazos", CLLocationCoordinate2D(latitude: 25.68000, longitude: -100.26417)),
    ("Lerdo de Tejada", CLLocationCoordinate2D(latitude: 25.67972, longitude: -100.25278)),
    ("Exposición", CLLocationCoordinate2D(latitude: 25.67944, longitude: -100.24556))
]

let stationsLine2: [(name: String, coordinate: CLLocationCoordinate2D)] = [
    ("Sendero", CLLocationCoordinate2D(latitude: 25.768777, longitude: -100.292885)),
    ("Santiago Tapia", CLLocationCoordinate2D(latitude: 25.759310, longitude: -100.295637)),
    ("San Nicolás", CLLocationCoordinate2D(latitude: 25.752918, longitude: -100.297955)),
    ("Anáhuac", CLLocationCoordinate2D(latitude: 25.739937, longitude: -100.302611)),
    ("Universidad", CLLocationCoordinate2D(latitude: 25.724393, longitude: -100.308219)),
    ("Niños Heroes", CLLocationCoordinate2D(latitude: 25.717016, longitude: -100.310859)),
    ("Regina", CLLocationCoordinate2D(latitude: 25.708157, longitude: -100.313997)),
    ("General Anaya", CLLocationCoordinate2D(latitude: 25.696674, longitude: -100.316846)),
    ("Cuauhtémoc", CLLocationCoordinate2D(latitude: 25.686071, longitude: -100.316892)),
    ("Alameda", CLLocationCoordinate2D(latitude: 25.677023, longitude: -100.318135)),
    ("Fundadores", CLLocationCoordinate2D(latitude: 25.672224, longitude: -100.318765)),
    ("Padre Mier", CLLocationCoordinate2D(latitude: 25.668630, longitude: -100.315588)),
    ("General I. Zaragoza", CLLocationCoordinate2D(latitude: 25.667752, longitude: -100.310202)),
]

let stationsLine3: [(name: String, coordinate: CLLocationCoordinate2D)] = [
    ("General I. Zaragoza", CLLocationCoordinate2D(latitude: 25.667752, longitude: -100.310202)),
    ("Santa Lucía", CLLocationCoordinate2D(latitude: 25.671395, longitude: -100.298547)),
    ("Colonia Obrera", CLLocationCoordinate2D(latitude: 25.677887, longitude: -100.297658)),
    ("Félix U. Gómez", CLLocationCoordinate2D(latitude: 25.683922, longitude: -100.296836)),
    ("Metalúrgicos", CLLocationCoordinate2D(latitude: 25.691021, longitude: -100.295814)),
    ("Moderna", CLLocationCoordinate2D(latitude: 25.700462, longitude: -100.292594)),
    ("Ruiz Cortinez", CLLocationCoordinate2D(latitude: 25.703204, longitude: -100.288702)),
    ("Los Ángeles", CLLocationCoordinate2D(latitude: 25.708125, longitude: -100.281714)),
    ("Hospital Metropolitano", CLLocationCoordinate2D(latitude: 25.713763, longitude: -100.273595)),
]

// Coordinates for curved lines - Line 1
let curvedPathCoordinates: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 25.6790443, longitude: -100.2414310),
    CLLocationCoordinate2D(latitude: 25.6792699, longitude: -100.2433402),
    CLLocationCoordinate2D(latitude: 25.6795043, longitude: -100.2454920),
    CLLocationCoordinate2D(latitude: 25.6797233, longitude: -100.2473393),
    CLLocationCoordinate2D(latitude: 25.6798275, longitude: -100.2480310),
    CLLocationCoordinate2D(latitude: 25.6798224, longitude: -100.2482646),
    CLLocationCoordinate2D(latitude: 25.6798487, longitude: -100.2483762),
    CLLocationCoordinate2D(latitude: 25.6798389, longitude: -100.2487004),
    CLLocationCoordinate2D(latitude: 25.6798078, longitude: -100.2515844),
    CLLocationCoordinate2D(latitude: 25.6798006, longitude: -100.2522490),
    CLLocationCoordinate2D(latitude: 25.6797953, longitude: -100.2528395),
    CLLocationCoordinate2D(latitude: 25.6797829, longitude: -100.2542354),
    CLLocationCoordinate2D(latitude: 25.6797625, longitude: -100.2558901),
    CLLocationCoordinate2D(latitude: 25.6797595, longitude: -100.2561371),
    CLLocationCoordinate2D(latitude: 25.6797227, longitude: -100.2588058),
    CLLocationCoordinate2D(latitude: 25.6797153, longitude: -100.2596672),
    CLLocationCoordinate2D(latitude: 25.6796124, longitude: -100.2615467),
    CLLocationCoordinate2D(latitude: 25.6795979, longitude: -100.2620014),
    CLLocationCoordinate2D(latitude: 25.6796462, longitude: -100.2625926),
    CLLocationCoordinate2D(latitude: 25.6797166, longitude: -100.2629777),
    CLLocationCoordinate2D(latitude: 25.6800672, longitude: -100.2642540),
    CLLocationCoordinate2D(latitude: 25.6803750, longitude: -100.2653702),
    CLLocationCoordinate2D(latitude: 25.6804755, longitude: -100.2657901),
    CLLocationCoordinate2D(latitude: 25.6805436, longitude: -100.2661820),
    CLLocationCoordinate2D(latitude: 25.6808149, longitude: -100.2683274),
    CLLocationCoordinate2D(latitude: 25.6810479, longitude: -100.2702950),
    CLLocationCoordinate2D(latitude: 25.6812616, longitude: -100.2722519),
    CLLocationCoordinate2D(latitude: 25.6814426, longitude: -100.2740492),
    CLLocationCoordinate2D(latitude: 25.6814606, longitude: -100.2743977),
    CLLocationCoordinate2D(latitude: 25.6815199, longitude: -100.2748742),
    CLLocationCoordinate2D(latitude: 25.6816305, longitude: -100.2752822),
    CLLocationCoordinate2D(latitude: 25.6822795, longitude: -100.2773179),
    CLLocationCoordinate2D(latitude: 25.6824555, longitude: -100.2777862),
    CLLocationCoordinate2D(latitude: 25.6825464, longitude: -100.2779883),
    CLLocationCoordinate2D(latitude: 25.6828462, longitude: -100.2786022),
    CLLocationCoordinate2D(latitude: 25.6832309, longitude: -100.2794460),
    CLLocationCoordinate2D(latitude: 25.6836648, longitude: -100.2803085),
    CLLocationCoordinate2D(latitude: 25.6838030, longitude: -100.2806510),
    CLLocationCoordinate2D(latitude: 25.6838998, longitude: -100.2809679),
    CLLocationCoordinate2D(latitude: 25.6839480, longitude: -100.2812969),
    CLLocationCoordinate2D(latitude: 25.6839647, longitude: -100.2816141),
    CLLocationCoordinate2D(latitude: 25.6839450, longitude: -100.2821543),
    CLLocationCoordinate2D(latitude: 25.6837161, longitude: -100.2850958),
    CLLocationCoordinate2D(latitude: 25.6837042, longitude: -100.2859049),
    CLLocationCoordinate2D(latitude: 25.6837143, longitude: -100.2881700),
    CLLocationCoordinate2D(latitude: 25.6837423, longitude: -100.2894312),
    CLLocationCoordinate2D(latitude: 25.6837429, longitude: -100.2918440),
    CLLocationCoordinate2D(latitude: 25.6838025, longitude: -100.2932640),
    CLLocationCoordinate2D(latitude: 25.6838081, longitude: -100.2940096),
    CLLocationCoordinate2D(latitude: 25.6839038, longitude: -100.2957028),
    CLLocationCoordinate2D(latitude: 25.6839217, longitude: -100.2962115),
    CLLocationCoordinate2D(latitude: 25.6839868, longitude: -100.2969920),
    CLLocationCoordinate2D(latitude: 25.6841442, longitude: -100.2983636),
    CLLocationCoordinate2D(latitude: 25.6843836, longitude: -100.3004506),
    CLLocationCoordinate2D(latitude: 25.6850668, longitude: -100.3066260),
    CLLocationCoordinate2D(latitude: 25.6853755, longitude: -100.3094676),
    CLLocationCoordinate2D(latitude: 25.6861218, longitude: -100.3169480),
    CLLocationCoordinate2D(latitude: 25.6862243, longitude: -100.3179244),
    CLLocationCoordinate2D(latitude: 25.6863460, longitude: -100.3188079),
    CLLocationCoordinate2D(latitude: 25.6863904, longitude: -100.3191299),
    CLLocationCoordinate2D(latitude: 25.6867116, longitude: -100.3214606),
    CLLocationCoordinate2D(latitude: 25.6868416, longitude: -100.3227387),
    CLLocationCoordinate2D(latitude: 25.6869957, longitude: -100.3243020),
    CLLocationCoordinate2D(latitude: 25.6873768, longitude: -100.3290395),
    CLLocationCoordinate2D(latitude: 25.6873768, longitude: -100.3294515),
    CLLocationCoordinate2D(latitude: 25.6873459, longitude: -100.3298034),
    CLLocationCoordinate2D(latitude: 25.6872653, longitude: -100.3301154),
    CLLocationCoordinate2D(latitude: 25.6871439, longitude: -100.3305569),
    CLLocationCoordinate2D(latitude: 25.6869656, longitude: -100.3310926),
    CLLocationCoordinate2D(latitude: 25.6868753, longitude: -100.3314446),
    CLLocationCoordinate2D(latitude: 25.6867975, longitude: -100.3319115),
    CLLocationCoordinate2D(latitude: 25.6868028, longitude: -100.3323507),
    CLLocationCoordinate2D(latitude: 25.6869227, longitude: -100.3334980),
    CLLocationCoordinate2D(latitude: 25.6875702, longitude: -100.3394937),
    CLLocationCoordinate2D(latitude: 25.6876297, longitude: -100.3399879),
    CLLocationCoordinate2D(latitude: 25.6877713, longitude: -100.3406438),
    CLLocationCoordinate2D(latitude: 25.6879569, longitude: -100.3415093),
    CLLocationCoordinate2D(latitude: 25.6880764, longitude: -100.3420068),
    CLLocationCoordinate2D(latitude: 25.6882113, longitude: -100.3423426),
    CLLocationCoordinate2D(latitude: 25.6883437, longitude: -100.3426351),
    CLLocationCoordinate2D(latitude: 25.6885677, longitude: -100.3429544),
    CLLocationCoordinate2D(latitude: 25.6887892, longitude: -100.3431777),
    CLLocationCoordinate2D(latitude: 25.6893801, longitude: -100.3436221),
    CLLocationCoordinate2D(latitude: 25.6898965, longitude: -100.3439564),
    CLLocationCoordinate2D(latitude: 25.6901889, longitude: -100.3440846),
    CLLocationCoordinate2D(latitude: 25.6906344, longitude: -100.3442041),
    CLLocationCoordinate2D(latitude: 25.6910659, longitude: -100.3442046),
    CLLocationCoordinate2D(latitude: 25.6918495, longitude: -100.3441090),
    CLLocationCoordinate2D(latitude: 25.6987474, longitude: -100.3431880),
    CLLocationCoordinate2D(latitude: 25.7007036, longitude: -100.3429360),
    CLLocationCoordinate2D(latitude: 25.7046230, longitude: -100.3424179),
    CLLocationCoordinate2D(latitude: 25.7049840, longitude: -100.3423971),
    CLLocationCoordinate2D(latitude: 25.7059242, longitude: -100.3424003),
    CLLocationCoordinate2D(latitude: 25.7065793, longitude: -100.3424093),
    CLLocationCoordinate2D(latitude: 25.7090342, longitude: -100.3424303),
    CLLocationCoordinate2D(latitude: 25.7093161, longitude: -100.3424331),
    CLLocationCoordinate2D(latitude: 25.7115397, longitude: -100.3424518),
    CLLocationCoordinate2D(latitude: 25.7129159, longitude: -100.3424531),
    CLLocationCoordinate2D(latitude: 25.7142417, longitude: -100.3424796),
    CLLocationCoordinate2D(latitude: 25.7157426, longitude: -100.3424900),
    CLLocationCoordinate2D(latitude: 25.7189393, longitude: -100.3425164),
    CLLocationCoordinate2D(latitude: 25.7233152, longitude: -100.3425450),
    CLLocationCoordinate2D(latitude: 25.7242145, longitude: -100.3425569),
    CLLocationCoordinate2D(latitude: 25.7245744, longitude: -100.3425840),
    CLLocationCoordinate2D(latitude: 25.7248884, longitude: -100.3426693),
    CLLocationCoordinate2D(latitude: 25.7252073, longitude: -100.3428092),
    CLLocationCoordinate2D(latitude: 25.7254857, longitude: -100.3429734),
    CLLocationCoordinate2D(latitude: 25.7309356, longitude: -100.3464747),
    CLLocationCoordinate2D(latitude: 25.7321485, longitude: -100.3472600),
    CLLocationCoordinate2D(latitude: 25.7379982, longitude: -100.3510293),
    CLLocationCoordinate2D(latitude: 25.7381683, longitude: -100.3511666),
    CLLocationCoordinate2D(latitude: 25.7383848, longitude: -100.3513726),
    CLLocationCoordinate2D(latitude: 25.7387846, longitude: -100.3517707),
    CLLocationCoordinate2D(latitude: 25.7394551, longitude: -100.3524470),
    CLLocationCoordinate2D(latitude: 25.7409998, longitude: -100.3540049),
    CLLocationCoordinate2D(latitude: 25.7418717, longitude: -100.3549080),
    CLLocationCoordinate2D(latitude: 25.7421666, longitude: -100.3552134),
    CLLocationCoordinate2D(latitude: 25.7424792, longitude: -100.3555361),
    CLLocationCoordinate2D(latitude: 25.7464009, longitude: -100.3595852),
    CLLocationCoordinate2D(latitude: 25.7483890, longitude: -100.3616380),
    CLLocationCoordinate2D(latitude: 25.7503309, longitude: -100.3637025),
    CLLocationCoordinate2D(latitude: 25.7505696, longitude: -100.3639107),
    CLLocationCoordinate2D(latitude: 25.7508423, longitude: -100.3640484),
    CLLocationCoordinate2D(latitude: 25.7514529, longitude: -100.3643738),
    CLLocationCoordinate2D(latitude: 25.7520258, longitude: -100.3646148),
    CLLocationCoordinate2D(latitude: 25.7527448, longitude: -100.3647842),
    CLLocationCoordinate2D(latitude: 25.7534574, longitude: -100.3650960),
    CLLocationCoordinate2D(latitude: 25.7544675, longitude: -100.3655645),
    CLLocationCoordinate2D(latitude: 25.7550613, longitude: -100.3658722)
]

// Coordinates for curved lines - Line 2
let curvedPathCoordinatesLine2: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 25.7687766, longitude: -100.2928846),
    CLLocationCoordinate2D(latitude: 25.7679915, longitude: -100.2929852),
    CLLocationCoordinate2D(latitude: 25.7671533, longitude: -100.2931086),
    CLLocationCoordinate2D(latitude: 25.7657064, longitude: -100.2933795),
    CLLocationCoordinate2D(latitude: 25.7652571, longitude: -100.2934814),
    CLLocationCoordinate2D(latitude: 25.7648875, longitude: -100.2935834),
    CLLocationCoordinate2D(latitude: 25.7642716, longitude: -100.2937577),
    CLLocationCoordinate2D(latitude: 25.7635397, longitude: -100.2940152),
    CLLocationCoordinate2D(latitude: 25.7625552, longitude: -100.2943712),
    CLLocationCoordinate2D(latitude: 25.7622715, longitude: -100.2944738),
    CLLocationCoordinate2D(latitude: 25.7607641, longitude: -100.2951015),
    CLLocationCoordinate2D(latitude: 25.7593099, longitude: -100.2956370),
    CLLocationCoordinate2D(latitude: 25.7579330, longitude: -100.2961341),
    CLLocationCoordinate2D(latitude: 25.7557950, longitude: -100.2969093),
    CLLocationCoordinate2D(latitude: 25.7554770, longitude: -100.2970102),
    CLLocationCoordinate2D(latitude: 25.7532513, longitude: -100.2978342),
    CLLocationCoordinate2D(latitude: 25.7529179, longitude: -100.2979550),
    CLLocationCoordinate2D(latitude: 25.7526392, longitude: -100.2980567),
    CLLocationCoordinate2D(latitude: 25.7513969, longitude: -100.2985080),
    CLLocationCoordinate2D(latitude: 25.7499319, longitude: -100.2990121),
    CLLocationCoordinate2D(latitude: 25.7483543, longitude: -100.2995835),
    CLLocationCoordinate2D(latitude: 25.7476994, longitude: -100.2998181),
    CLLocationCoordinate2D(latitude: 25.7463032, longitude: -100.3003184),
    CLLocationCoordinate2D(latitude: 25.7448053, longitude: -100.3008575),
    CLLocationCoordinate2D(latitude: 25.7426889, longitude: -100.3016192),
    CLLocationCoordinate2D(latitude: 25.7411813, longitude: -100.3021745),
    CLLocationCoordinate2D(latitude: 25.7402339, longitude: -100.3025074),
    CLLocationCoordinate2D(latitude: 25.7399370, longitude: -100.3026110),
    CLLocationCoordinate2D(latitude: 25.7386396, longitude: -100.3030703),
    CLLocationCoordinate2D(latitude: 25.7363946, longitude: -100.3038934),
    CLLocationCoordinate2D(latitude: 25.7343606, longitude: -100.3046083),
    CLLocationCoordinate2D(latitude: 25.7332925, longitude: -100.3050224),
    CLLocationCoordinate2D(latitude: 25.7322149, longitude: -100.3054117),
    CLLocationCoordinate2D(latitude: 25.7319113, longitude: -100.3055124),
    CLLocationCoordinate2D(latitude: 25.7307675, longitude: -100.3059036),
    CLLocationCoordinate2D(latitude: 25.7282113, longitude: -100.3068308),
    CLLocationCoordinate2D(latitude: 25.7260463, longitude: -100.3076140),
    CLLocationCoordinate2D(latitude: 25.7249582, longitude: -100.3080181),
    CLLocationCoordinate2D(latitude: 25.7243927, longitude: -100.3082191),
    CLLocationCoordinate2D(latitude: 25.7238473, longitude: -100.3084129),
    CLLocationCoordinate2D(latitude: 25.7216851, longitude: -100.3091648),
    CLLocationCoordinate2D(latitude: 25.7194881, longitude: -100.3099743),
    CLLocationCoordinate2D(latitude: 25.7178401, longitude: -100.3105617),
    CLLocationCoordinate2D(latitude: 25.7170160, longitude: -100.3108590),
    CLLocationCoordinate2D(latitude: 25.7150707, longitude: -100.3115461),
    CLLocationCoordinate2D(latitude: 25.7136951, longitude: -100.3120371),
    CLLocationCoordinate2D(latitude: 25.7118837, longitude: -100.3126625),
    CLLocationCoordinate2D(latitude: 25.7114772, longitude: -100.3128026),
    CLLocationCoordinate2D(latitude: 25.7096821, longitude: -100.3134114),
    CLLocationCoordinate2D(latitude: 25.7091937, longitude: -100.3136232),
    CLLocationCoordinate2D(latitude: 25.7088089, longitude: -100.3137581),
    CLLocationCoordinate2D(latitude: 25.7081567, longitude: -100.3139970),
    CLLocationCoordinate2D(latitude: 25.7052711, longitude: -100.3150973),
    CLLocationCoordinate2D(latitude: 25.7027156, longitude: -100.3161073),
    CLLocationCoordinate2D(latitude: 25.7026292, longitude: -100.3161414),
    CLLocationCoordinate2D(latitude: 25.7025160, longitude: -100.3161862),
    CLLocationCoordinate2D(latitude: 25.7016918, longitude: -100.3164517),
    CLLocationCoordinate2D(latitude: 25.7008822, longitude: -100.3167065),
    CLLocationCoordinate2D(latitude: 25.7002296, longitude: -100.3168272),
    CLLocationCoordinate2D(latitude: 25.6986997, longitude: -100.3168353),
    CLLocationCoordinate2D(latitude: 25.6971336, longitude: -100.3168407),
    CLLocationCoordinate2D(latitude: 25.6966744, longitude: -100.3168460),
    CLLocationCoordinate2D(latitude: 25.6949583, longitude: -100.3168246),
    CLLocationCoordinate2D(latitude: 25.6930876, longitude: -100.3168004),
    CLLocationCoordinate2D(latitude: 25.6922851, longitude: -100.3167870),
    CLLocationCoordinate2D(latitude: 25.6908252, longitude: -100.3167870),
    CLLocationCoordinate2D(latitude: 25.6901726, longitude: -100.3167621),
    CLLocationCoordinate2D(latitude: 25.6894238, longitude: -100.3167404),
    CLLocationCoordinate2D(latitude: 25.6889332, longitude: -100.3167530),
    CLLocationCoordinate2D(latitude: 25.6874161, longitude: -100.3167757),
    CLLocationCoordinate2D(latitude: 25.6863414, longitude: -100.3168533),
    CLLocationCoordinate2D(latitude: 25.6860710, longitude: -100.3168920),
    CLLocationCoordinate2D(latitude: 25.6853150, longitude: -100.3170003),
    CLLocationCoordinate2D(latitude: 25.6838472, longitude: -100.3172110),
    CLLocationCoordinate2D(latitude: 25.6818769, longitude: -100.3174807),
    CLLocationCoordinate2D(latitude: 25.6809016, longitude: -100.3176011),
    CLLocationCoordinate2D(latitude: 25.6770232, longitude: -100.3181350),
    CLLocationCoordinate2D(latitude: 25.6741416, longitude: -100.3185592),
    CLLocationCoordinate2D(latitude: 25.6722242, longitude: -100.3187650),
    CLLocationCoordinate2D(latitude: 25.6706696, longitude: -100.3190032),
    CLLocationCoordinate2D(latitude: 25.6704757, longitude: -100.3190219),
    CLLocationCoordinate2D(latitude: 25.6702812, longitude: -100.3190142),
    CLLocationCoordinate2D(latitude: 25.6700890, longitude: -100.3189802),
    CLLocationCoordinate2D(latitude: 25.6699020, longitude: -100.3189204),
    CLLocationCoordinate2D(latitude: 25.6697229, longitude: -100.3188357),
    CLLocationCoordinate2D(latitude: 25.6695545, longitude: -100.3187274),
    CLLocationCoordinate2D(latitude: 25.6693993, longitude: -100.3185972),
    CLLocationCoordinate2D(latitude: 25.6692596, longitude: -100.3184469),
    CLLocationCoordinate2D(latitude: 25.6691375, longitude: -100.3182787),
    CLLocationCoordinate2D(latitude: 25.6690348, longitude: -100.3180953),
    CLLocationCoordinate2D(latitude: 25.6689530, longitude: -100.3178994),
    CLLocationCoordinate2D(latitude: 25.6688934, longitude: -100.3176938),
    CLLocationCoordinate2D(latitude: 25.6688568, longitude: -100.3174817),
    CLLocationCoordinate2D(latitude: 25.6687861, longitude: -100.3169446),
    CLLocationCoordinate2D(latitude: 25.6686300, longitude: -100.3155883),
    CLLocationCoordinate2D(latitude: 25.6685325, longitude: -100.3147276),
    CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
]

// Coordinates for curved lines - Line 3
let curvedPathCoordinatesLine3: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 25.7147319, longitude: -100.2721709),
    CLLocationCoordinate2D(latitude: 25.7137634, longitude: -100.2735950),
    CLLocationCoordinate2D(latitude: 25.7081248, longitude: -100.2817140),
    CLLocationCoordinate2D(latitude: 25.7063372, longitude: -100.2842931),
    CLLocationCoordinate2D(latitude: 25.7032038, longitude: -100.2887021),
    CLLocationCoordinate2D(latitude: 25.7015205, longitude: -100.2910786),
    CLLocationCoordinate2D(latitude: 25.7004620, longitude: -100.2925940),
    CLLocationCoordinate2D(latitude: 25.6946223, longitude: -100.2952712),
    CLLocationCoordinate2D(latitude: 25.6910212, longitude: -100.2958140),
    CLLocationCoordinate2D(latitude: 25.6882480, longitude: -100.2962444),
    CLLocationCoordinate2D(latitude: 25.6839217, longitude: -100.2968360),
    CLLocationCoordinate2D(latitude: 25.6778869, longitude: -100.2976580),
    CLLocationCoordinate2D(latitude: 25.6747188, longitude: -100.2981028),
    CLLocationCoordinate2D(latitude: 25.6713947, longitude: -100.2985470),
    CLLocationCoordinate2D(latitude: 25.6702685, longitude: -100.2986943),
    CLLocationCoordinate2D(latitude: 25.6696848, longitude: -100.2987837),
    CLLocationCoordinate2D(latitude: 25.6695725, longitude: -100.2988108),
    CLLocationCoordinate2D(latitude: 25.6693911, longitude: -100.2988715),
    CLLocationCoordinate2D(latitude: 25.6692308, longitude: -100.2989354),
    CLLocationCoordinate2D(latitude: 25.6690996, longitude: -100.2990013),
    CLLocationCoordinate2D(latitude: 25.6689078, longitude: -100.2991131),
    CLLocationCoordinate2D(latitude: 25.6687524, longitude: -100.2992271),
    CLLocationCoordinate2D(latitude: 25.6686131, longitude: -100.2993411),
    CLLocationCoordinate2D(latitude: 25.6684796, longitude: -100.2994779),
    CLLocationCoordinate2D(latitude: 25.6683398, longitude: -100.2996454),
    CLLocationCoordinate2D(latitude: 25.6682440, longitude: -100.2997841),
    CLLocationCoordinate2D(latitude: 25.6681269, longitude: -100.2999759),
    CLLocationCoordinate2D(latitude: 25.6680450, longitude: -100.3001236),
    CLLocationCoordinate2D(latitude: 25.6678410, longitude: -100.3005253),
    CLLocationCoordinate2D(latitude: 25.6675082, longitude: -100.3011492),
    CLLocationCoordinate2D(latitude: 25.6669596, longitude: -100.3021769),
    CLLocationCoordinate2D(latitude: 25.6668530, longitude: -100.3023998),
    CLLocationCoordinate2D(latitude: 25.6665927, longitude: -100.3029473),
    CLLocationCoordinate2D(latitude: 25.6665573, longitude: -100.3030327),
    CLLocationCoordinate2D(latitude: 25.6665212, longitude: -100.3031289),
    CLLocationCoordinate2D(latitude: 25.6664995, longitude: -100.3032084),
    CLLocationCoordinate2D(latitude: 25.6664873, longitude: -100.3032788),
    CLLocationCoordinate2D(latitude: 25.6664799, longitude: -100.3033742),
    CLLocationCoordinate2D(latitude: 25.6664831, longitude: -100.3034579),
    CLLocationCoordinate2D(latitude: 25.6664958, longitude: -100.3036018),
    CLLocationCoordinate2D(latitude: 25.6665336, longitude: -100.3038826),
    CLLocationCoordinate2D(latitude: 25.6667067, longitude: -100.3048954),
    CLLocationCoordinate2D(latitude: 25.6676930, longitude: -100.3097754),
    CLLocationCoordinate2D(latitude: 25.6677517, longitude: -100.3102020)
]

struct MetroStation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct StationDetailSheet: View {
    var station: MetroStation
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Text(station.name)
                .font(.title2)
                .bold()
            
            if isLoading {
                ProgressView()
                    .frame(height: 200)
            } else if let scene = lookAroundScene {
                if #available(iOS 17.0, *) {
                    LookAroundPreview(initialScene: scene)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    // Fallback for iOS 16
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 200)
                        .overlay(Text("Look Around not available on this iOS version").foregroundColor(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 200)
                    .overlay(Text("Vista no disponible").foregroundColor(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Text("Coordenadas: \(station.coordinate.latitude), \(station.coordinate.longitude)")
                .font(.caption)

            Spacer()
        }
        .padding()
        .task {
            await loadLookAroundScene()
        }
    }
    
    private func loadLookAroundScene() async {
        let request = MKLookAroundSceneRequest(coordinate: station.coordinate)
        
        do {
            let scene = try await request.scene
            await MainActor.run {
                self.lookAroundScene = scene
                self.isLoading = false
            }
        } catch {
            print("Error cargando Look Around: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

class SearchCompleterWrapper: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .pointOfInterest
    }
    
    func search(with query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error getting search results: \(error.localizedDescription)")
    }
}

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: CLLocation?
    @State private var position: MapCameraPosition
    @State private var pinLocation: CLLocationCoordinate2D
    @State private var searchText = ""
    @State private var showSearchResults = false
    @StateObject private var searchCompleter = SearchCompleterWrapper()
    @State private var selectedStation: MetroStation? = nil
    @State private var showMetroLines = true
    
    init(selectedLocation: Binding<CLLocation?>, initialLocation: CLLocation?) {
        _selectedLocation = selectedLocation
        let initialCoordinate = initialLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 25.6694, longitude: -100.3098)
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: initialCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
        _pinLocation = State(initialValue: initialCoordinate)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Map view with metro stations and lines
                MapViewWithMetro(
                    position: $position,
                    pinLocation: $pinLocation,
                    selectedStation: $selectedStation,
                    showMetroLines: showMetroLines
                )
                .ignoresSafeArea(edges: .bottom)
                
                // Search bar and results
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search location", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled()
                            .onReceive(Just(searchText)) { value in
                                if value.isEmpty {
                                    showSearchResults = false
                                } else {
                                    searchCompleter.search(with: value)
                                    showSearchResults = true
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                showSearchResults = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Toggle metro lines visibility
                        Button(action: {
                            showMetroLines.toggle()
                        }) {
                            Image(systemName: showMetroLines ? "tram.fill" : "tram")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(10)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                    
                    if showSearchResults && !searchCompleter.results.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(searchCompleter.results, id: \.self) { result in
                                    Button(action: {
                                        Task {
                                            await selectSearchResult(result)
                                        }
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(result.title)
                                                .foregroundColor(.primary)
                                                .font(.body)
                                            Text(result.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    Divider()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(maxHeight: 300)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Set Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Confirm") {
                        selectedLocation = CLLocation(
                            latitude: pinLocation.latitude,
                            longitude: pinLocation.longitude
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
            .sheet(item: $selectedStation) { station in
                StationDetailSheet(station: station)
                    .presentationDetents([.medium])
            }
        }
    }
    
    private func selectSearchResult(_ result: MKLocalSearchCompletion) async {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            if let item = response.mapItems.first {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: item.placemark.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                    pinLocation = item.placemark.coordinate
                }
                searchText = result.title
                showSearchResults = false
                selectedStation = nil
            }
        } catch {
            print("Error searching location: \(error.localizedDescription)")
        }
    }
    
    private func findStation(name: String) -> MetroStation? {
        // Search in line 1
        if let station = stations.first(where: { $0.name == name }) {
            return MetroStation(name: station.name, coordinate: station.coordinate)
        }
        // Search in line 2
        if let station = stationsLine2.first(where: { $0.name == name }) {
            return MetroStation(name: station.name, coordinate: station.coordinate)
        }
        // Search in line 3
        if let station = stationsLine3.first(where: { $0.name == name }) {
            return MetroStation(name: station.name, coordinate: station.coordinate)
        }
        return nil
    }
}

// MARK: - Map with Metro Lines
struct MapViewWithMetro: UIViewRepresentable {
    @Binding var position: MapCameraPosition
    @Binding var pinLocation: CLLocationCoordinate2D
    @Binding var selectedStation: MetroStation?
    var showMetroLines: Bool
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Enable map interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        
        // Set initial position
        if let region = position.region {
            mapView.setRegion(region, animated: false)
        }
        
        // Add pin annotation
        addPinAnnotation(to: mapView)
        
        // Add metro stations and lines if needed
        if showMetroLines {
            addMetroStations(to: mapView)
            addMetroLines(to: mapView)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update pin position
        updatePinAnnotation(in: mapView)
        
        // Handle metro visibility
        updateMetroDisplay(in: mapView)
    }
    
    private func addPinAnnotation(to mapView: MKMapView) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinLocation
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
    }
    
    private func updatePinAnnotation(in mapView: MKMapView) {
        let existingPins = mapView.annotations.compactMap { $0 as? MKPointAnnotation }
            .filter { $0.title == "Selected Location" }
        
        if let pin = existingPins.first {
            pin.coordinate = pinLocation
        } else {
            addPinAnnotation(to: mapView)
        }
    }
    
    private func updateMetroDisplay(in mapView: MKMapView) {
        let metroAnnotations = mapView.annotations.filter {
            if let title = ($0 as? MKPointAnnotation)?.title, title != "Selected Location" {
                return true
            }
            return false
        }
        
        let metroOverlays = mapView.overlays
        
        if showMetroLines {
            if metroAnnotations.isEmpty {
                addMetroStations(to: mapView)
            }
            if metroOverlays.isEmpty {
                addMetroLines(to: mapView)
            }
        } else {
            mapView.removeAnnotations(metroAnnotations)
            mapView.removeOverlays(metroOverlays)
        }
    }
    
    private func addMetroStations(to mapView: MKMapView) {
        // Add Line 1 stations
        for station in stations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = station.coordinate
            annotation.title = station.name
            annotation.subtitle = "Line 1"
            mapView.addAnnotation(annotation)
        }
        
        // Add Line 2 stations
        for station in stationsLine2 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = station.coordinate
            annotation.title = station.name
            annotation.subtitle = "Line 2"
            mapView.addAnnotation(annotation)
        }
        
        // Add Line 3 stations
        for station in stationsLine3 {
            let annotation = MKPointAnnotation()
            annotation.coordinate = station.coordinate
            annotation.title = station.name
            annotation.subtitle = "Line 3"
            mapView.addAnnotation(annotation)
        }
    }
    
    private func addMetroLines(to mapView: MKMapView) {
        // Add Line 1 (Yellow)
        let line1 = MKPolyline(coordinates: curvedPathCoordinates, count: curvedPathCoordinates.count)
        line1.title = "Line1"
        mapView.addOverlay(line1, level: .aboveRoads)
        
        // Add Line 2 (Green)
        let line2 = MKPolyline(coordinates: curvedPathCoordinatesLine2, count: curvedPathCoordinatesLine2.count)
        line2.title = "Line2"
        mapView.addOverlay(line2, level: .aboveRoads)
        
        // Add Line 3 (Orange)
        let line3 = MKPolyline(coordinates: curvedPathCoordinatesLine3, count: curvedPathCoordinatesLine3.count)
        line3.title = "Line3"
        mapView.addOverlay(line3, level: .aboveRoads)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWithMetro
        
        init(_ parent: MapViewWithMetro) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Update the position binding with the new center coordinate
            self.parent.pinLocation = mapView.region.center
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation,
                  let title = annotation.title,
                  title != "Selected Location" else {
                return
            }
            
            // Create a station from the selected annotation
            let station = MetroStation(name: title ?? "", coordinate: annotation.coordinate)
            parent.selectedStation = station
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // Set line colors based on line number
                if polyline.title == "Line1" {
                    renderer.strokeColor = .systemYellow
                } else if polyline.title == "Line2" {
                    renderer.strokeColor = .systemGreen
                } else if polyline.title == "Line3" {
                    renderer.strokeColor = .systemOrange
                } else {
                    renderer.strokeColor = .blue
                }
                
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Selected location pin
            if let title = annotation.title, title == "Selected Location" {
                let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "selectedLocation")
                markerView.markerTintColor = .red
                markerView.glyphImage = UIImage(systemName: "mappin")
                return markerView
            }
            
            // Station marker
            let identifier = "stationMarker"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
            } else {
                view?.annotation = annotation
            }
            
            // Set color based on which metro line the station belongs to
            if let subtitle = annotation.subtitle {
                if subtitle == "Line 1" {
                    view?.markerTintColor = .systemYellow
                } else if subtitle == "Line 2" {
                    view?.markerTintColor = .systemGreen
                } else if subtitle == "Line 3" {
                    view?.markerTintColor = .systemOrange
                }
            }
            
            view?.glyphText = "🚇"
            return view
        }
    }
}

#Preview {
    LocationPickerView(
        selectedLocation: .constant(nil),
        initialLocation: CLLocation(latitude: 25.6694, longitude: -100.3098)
    )
}
