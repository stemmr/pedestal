//
//  Posts.swift
//  Pedestal
//
//  Created by Arthur Stemmer on 10/24/24.
//

import Foundation

struct Post: Identifiable {
    let id: UUID
    let title: String
    let summary: String
    let content: String
    let bookmarked: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        content: String,
        bookmarked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.bookmarked = bookmarked
    }
}

@MainActor
class Posts: ObservableObject {
    @Published private(set) var posts: [Post] = []
    
    func addPost(post: Post) {
        self.posts.append(post)
    }
}

extension Posts {
    static var preview: Posts {
        let posts = Posts()
        
        posts.addPost(post: Post(
            title: "The Rise and Fall of Julius Caesar",
            summary: """
                     From brilliant military commander to controversial dictator, Caesar's life shaped the course of Roman history.
                     Explore his conquest of Gaul, crossing of the Rubicon, and the dramatic events leading to his assassination on the Ides of March.
                     """,
            content: """
            # Julius Caesar: Rome's Most Famous Leader
            
            ## Early Life and Rise to Power
            Born into a patrician family, Julius Caesar showed early promise in both politics and military strategy. His ambitious nature and charismatic personality helped him climb the ranks of Roman society, eventually securing key positions in the Republic.
            
            ## Military Conquests
            Caesar's military campaigns in Gaul demonstrated his exceptional tactical abilities. Over eight years, he conquered vast territories, wrote his famous "Commentaries on the Gallic War," and built a loyal army that would follow him into civil war.
            
            ### The Rubicon Decision
            > "The die is cast" - Julius Caesar
            
            When ordered to disband his army, Caesar made the fateful decision to cross the Rubicon River, effectively declaring civil war against Pompey and the Roman Senate.
            
            ## Legacy and Impact
            Caesar's reforms and policies:
            - Reformed the Roman calendar
            - Expanded citizenship rights
            - Initiated important public works projects
            - Established precedents for imperial rule
            
            His assassination in 44 BCE marked the end of the Roman Republic and the beginning of the Empire.
            """
        ))
        
        posts.addPost(post: Post(
            title: "The Parthenon: Athens' Crowning Glory",
            summary: """
                     Standing atop the Acropolis, the Parthenon represents the pinnacle of Classical Greek architecture.
                     Discover the mathematical precision, artistic innovation, and religious significance behind this iconic temple.
                     """,
            content: """
            # The Parthenon: Marvel of Ancient Architecture
            
            ## Construction and Design
            Built between 447-432 BCE under Pericles' leadership, the Parthenon showcases the remarkable precision of Greek architecture. Its subtle curves and optical refinements demonstrate unprecedented architectural sophistication.
            
            ### Mathematical Harmony
            The building incorporates the Golden Ratio throughout its proportions:
            - Column spacing
            - Facade dimensions
            - Interior arrangements
            
            ## Artistic Elements
            
            The temple originally housed:
            * The massive chryselephantine statue of Athena
            * The famous Parthenon frieze
            * Metopes depicting mythological battles
            
            > "The Parthenon represents the tangible achievement of the Greek ideal of perfection" - Architectural historian
            
            ## Through the Ages
            The building has served as:
            1. A Greek temple
            2. A Christian church
            3. An Ottoman mosque
            4. A symbol of Western civilization
            """
        ))
        
        posts.addPost(post: Post(
            title: "Alexander's Empire: From Macedonia to India",
            summary: """
                     Follow Alexander the Great's extraordinary journey from young king to world conqueror.
                     Uncover the strategies, battles, and cultural exchanges that created one of history's largest empires.
                     """,
            content: """
            # Alexander the Great: Conqueror of the Ancient World
            
            ## The Young King
            Ascending to the throne at just 20, Alexander inherited a powerful army and the ambitions of his father, Philip II. Under the tutelage of Aristotle, he developed both martial and intellectual prowess.
            
            ### Major Campaigns
            
            His conquests included:
            - The Persian Empire
            - Egypt
            - Bactria
            - Northwestern India
            
            ## Military Innovation
            
            Alexander revolutionized warfare through:
            * The use of the Macedonian phalanx
            * Cavalry tactics
            * Siege warfare techniques
            
            > "There is nothing impossible to him who will try" - Alexander the Great
            
            ## Cultural Legacy
            
            The Hellenistic world emerged from his conquests, creating:
            1. New trade routes
            2. Cultural fusion
            3. Scientific advancement
            4. Artistic innovation
            
            His empire, though short-lived, forever changed the ancient world.
            """
        ))
        
        posts.addPost(post: Post(
            title: "The Mystery of the Minoan Civilization",
            summary: """
                     Delve into the sophisticated Bronze Age civilization that flourished on Crete.
                     Explore their advanced architecture, mysterious writing systems, and the puzzling circumstances of their decline.
                     """,
            content: """
            # The Minoans: Europe's First Advanced Civilization
            
            ## Discovery and Excavation
            
            Sir Arthur Evans' excavations at Knossos revealed a sophisticated civilization that predated Classical Greece. The massive palace complexes and advanced urban planning showed remarkable technological achievement.
            
            ### Palace Culture
            
            The famous palaces featured:
            - Multiple stories
            - Complex plumbing systems
            - Beautiful frescoes
            - Storage magazines
            
            ## Writing and Administration
            
            Two main scripts were used:
            * Linear A (still undeciphered)
            * Linear B (early Greek)
            
            > "The Minoans were far more sophisticated than anyone imagined possible for their era"
            
            ## Mysterious Decline
            
            Theories about their disappearance include:
            1. Volcanic eruption
            2. Mycenaean invasion
            3. Environmental changes
            4. Economic collapse
            
            Their influence continued through their contributions to Greek civilization.
            """
        ))

        posts.addPost(post: Post(
            title: "The Rise and Fall of the Roman Republic",
            summary: """
                     From humble beginnings to empire - explore how the Roman Republic transformed from a small city-state into 
                     a Mediterranean superpower, and the factors that led to its eventual downfall.
                     """,
            content: """
            # The Roman Republic: Power, Politics, and Revolution
            
            ## Origins and Early History
            
            The Roman Republic was established around 509 BCE following the overthrow of the Roman Kingdom. The early Republic was marked by a struggle between patricians and plebeians, which eventually led to the creation of important political institutions that would define Roman governance for centuries.
            
            ### Key Political Institutions
            
            * The Senate - Advisory body composed of elite citizens
            * Consuls - Two annually elected chief magistrates
            * Popular Assemblies - Where citizens voted on laws and elected officials
            * Tribunes of the Plebs - Representatives protecting plebeian interests
            
            ## Military Expansion
            
            The Republic's military success was built on several innovative features:
            
            1. The Legion System
                * Flexible tactical units
                * Professional organization
                * Standardized equipment
                * Effective logistics
            
            2. Provincial Administration
                * Local autonomy under Roman oversight
                * Tax collection systems
                * Infrastructure development
                * Cultural integration
            
            ## Social and Economic Transformation
            
            As Rome expanded, its society underwent dramatic changes:
            
            ### Economic Changes
            * Development of a monetary economy
            * Growth of large-scale agriculture
            * Rise of a wealthy merchant class
            * Increased social mobility
            
            ### Social Issues
            * Growing wealth inequality
            * Rural displacement
            * Urban overcrowding
            * Slave economy expansion
            
            ## The Crisis of the Republic
            
            Several factors contributed to the Republic's decline:
            
            1. Military Reforms of Marius
                * Professional army loyal to generals
                * Weakened civilian control
            
            2. Political Violence
                * Assassination of the Gracchi
                * Sulla's dictatorship
                * Gang warfare in Rome
            
            3. Civil Wars
                * Marius vs. Sulla
                * Caesar vs. Pompey
                * Octavian vs. Antony
            
            ## Legacy
            
            The Roman Republic's influence continues today through:
            * Constitutional government concepts
            * Separation of powers
            * Legal principles
            * Latin language and literature
            * Architectural and engineering achievements
            
            > "The Republic was destroyed by its own success" - Modern historians often note how Rome's tremendous growth ultimately undermined its traditional institutions.
            """
        ))
        
        posts.addPost(post: Post(
            title: "The Industrial Revolution: Dawn of the Modern Age",
            summary: """
                     Exploring how technological innovation and social change transformed society,
                     from steam power to mass production, reshaping our world forever.
                     """,
            content: """
            # The Industrial Revolution: Birth of the Modern World
            
            ## Key Innovations
            
            The Industrial Revolution brought unprecedented technological change. Steam power and mechanization revolutionized manufacturing, transportation, and daily life.
            
            ### Transformative Technologies
            
            * Steam Engine
            * Power Loom
            * Telegraph
            * Mass Production
            
            ## Social Impact
            
            Several major changes occurred:
            
            1. Urbanization
            2. Rise of Factory System
            3. New Social Classes
            4. Public Education
            
            ### Major Challenges
            
            * Poor working conditions
            * Child labor
            * Urban poverty
            * Environmental pollution
            
            ## Economic Changes
            
            ### New Economic Systems
            * Capitalism
            * Banking networks
            * International trade
            * Stock markets
            
            ### Labor Changes
            * Worker movements
            * Trade unions
            * Labor laws
            * Wage system
            
            ## Geographic Centers
            
            Key industrial regions:
            * Great Britain
            * Germany
            * United States
            * France
            * Belgium
            
            ### Notable Developments
            
            1. Railway networks
            2. Factory cities
            3. Canal systems
            4. Steel production
            
            ## Long-Term Impact
            
            The revolution's effects continue:
            
            * Modern manufacturing
            * Global trade
            * Urban society
            * Environmental awareness
            
            > "The Industrial Revolution marked humanity's decisive break with its agricultural past."
            """
        ))
        
        posts.addPost(post: Post(
            title: "The Byzantine Empire: Rome's Eastern Legacy",
            summary: """
                     Discover the thousand-year story of Byzantium, from its origins as Rome's eastern half
                     to its fall to the Ottomans, and its lasting influence on art, law, and religion.
                     """,
            content: """
            # The Byzantine Empire: Medieval Splendor
            
            The Byzantine Empire preserved Roman civilization while developing its own distinct character, blending Greek, Roman, and Christian elements into a unique cultural synthesis.
            
            ## Imperial Elements
            
            * Greek language
            * Roman law
            * Christian faith
            * Imperial bureaucracy
            * Military tradition
            
            ### Cultural Achievements
            
            Key contributions include:
            - Hagia Sophia
            - Code of Justinian
            - Greek manuscript preservation
            - Iconic art
            
            ## Major Periods
            
            1. Justinian's Reconquest
            2. Dark Ages Survival
            3. Macedonian Renaissance
            4. Komnenian Restoration
            
            > "New Rome stood as civilization's beacon through the medieval period"
            
            Its influence shaped Eastern Europe and beyond.
            """
        ))
        
        posts.addPost(post: Post(
            title: "The Silk Road: Ancient Global Network",
            summary: """
                     Journey along history's most famous trade route, connecting East and West through
                     commerce, culture, and ideas for over two millennia.
                     """,
            content: """
            # The Ancient Silk Road
            
            ## Major Routes
            
            The network stretched across continents:
            * China to Rome
            * India to Persia
            * Central Asia links
            
            ### Key Commodities
            
            1. Silk and Textiles
            2. Spices and Gold
            3. Paper and Gunpowder
            
            ## Cultural Exchange
            
            Impact on civilizations:
            - Buddhism spread
            - Technology transfer
            - Artistic styles
            
            ## Trading Centers
            
            Famous cities include:
            * Chang'an
            * Samarkand
            * Baghdad
            * Constantinople
            
            Each hub fostered unique cultural fusion.
            """
        ))
        
        return posts
    }
}
