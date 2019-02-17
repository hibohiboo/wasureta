module InfoToData exposing (toData)

import InfoParser exposing (parse, Info)
import Graph
import Array


toData : List Info -> Graph.Graph String ()
toData informations =
    Graph.fromNodeLabelsAndEdgePairs
        (List.map
            (\info -> info.title)
            informations
        )
        (Array.toList
            (Array.indexedMap (\i info -> ( 0, 1 )) (Array.fromList informations))
        )
