/*
  # Create Pokemon Database Schema

  1. New Tables
    - `pokemon`
      - `id` (integer, primary key)
      - `name` (text)
      - `types` (text array)
      - `description` (text)
      - `created_at` (timestamp with timezone)

  2. Security
    - Enable RLS on `pokemon` table
    - Add policy for public read access (if not exists)
*/

-- Create the pokemon table if it doesn't exist
CREATE TABLE IF NOT EXISTS pokemon (
  id integer PRIMARY KEY,
  name text NOT NULL,
  types text[] NOT NULL,
  description text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE pokemon ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'pokemon' 
    AND policyname = 'Allow public read access'
  ) THEN
    CREATE POLICY "Allow public read access"
      ON pokemon
      FOR SELECT
      TO public
      USING (true);
  END IF;
END $$;

-- Insert all 151 Pokemon if they don't exist
INSERT INTO pokemon (id, name, types, description)
SELECT * FROM (VALUES
  (1, 'Bulbasaur', ARRAY['grass', 'poison'], 'For some time after its birth, it uses the nutrients that are packed into the seed on its back in order to grow.'),
  (2, 'Ivysaur', ARRAY['grass', 'poison'], 'The more sunlight Ivysaur bathes in, the more strength wells up within it, allowing the bud on its back to grow larger.'),
  (3, 'Venusaur', ARRAY['grass', 'poison'], 'While it basks in the sun, it can convert the light into energy. As a result, it is more powerful in the summertime.'),
  (4, 'Charmander', ARRAY['fire'], 'The flame on its tail shows the strength of its life-force. If Charmander is weak, the flame also burns weakly.'),
  (5, 'Charmeleon', ARRAY['fire'], 'When it swings its burning tail, the temperature around it rises higher and higher, tormenting its opponents.'),
  (6, 'Charizard', ARRAY['fire', 'flying'], 'If Charizard becomes truly angered, the flame at the tip of its tail burns in a light blue shade.'),
  (7, 'Squirtle', ARRAY['water'], 'After birth, its back swells and hardens into a shell. It sprays a potent foam from its mouth.'),
  (8, 'Wartortle', ARRAY['water'], 'Wartortle''s long, furry tail is a symbol of longevity, so this Pokémon is quite popular among older people.'),
  (9, 'Blastoise', ARRAY['water'], 'It deliberately increases its body weight so it can withstand the recoil of the water jets it fires.'),
  (10, 'Caterpie', ARRAY['bug'], 'For protection, it releases a horrible stench from the antenna on its head to drive away enemies.'),
  (11, 'Metapod', ARRAY['bug'], 'It is waiting for the moment to evolve. At this stage, it can only harden, so it remains motionless to avoid attack.'),
  (12, 'Butterfree', ARRAY['bug', 'flying'], 'It loves the nectar of flowers and can locate flower patches that have even tiny amounts of pollen.'),
  (13, 'Weedle', ARRAY['bug', 'poison'], 'Beware of the sharp stinger on its head. It hides in grass and bushes where it eats leaves.'),
  (14, 'Kakuna', ARRAY['bug', 'poison'], 'Able to move only slightly. When endangered, it may stick out its stinger and poison its enemy.'),
  (15, 'Beedrill', ARRAY['bug', 'poison'], 'It has three poisonous stingers on its forelegs and its tail. They are used to jab its enemy repeatedly.'),
  (16, 'Pidgey', ARRAY['normal', 'flying'], 'Very docile. If attacked, it will often kick up sand to protect itself rather than fight back.'),
  (17, 'Pidgeotto', ARRAY['normal', 'flying'], 'This Pokémon is full of vitality. It constantly flies around its large territory in search of prey.'),
  (18, 'Pidgeot', ARRAY['normal', 'flying'], 'This Pokémon flies at Mach 2 speed, seeking prey. Its large talons are feared as wicked weapons.'),
  (19, 'Rattata', ARRAY['normal'], 'Will chew on anything with its fangs. If you see one, you can be certain that 40 more live in the area.'),
  (20, 'Raticate', ARRAY['normal'], 'Its hind feet are webbed. They act as flippers, so it can swim in rivers and hunt for prey.'),
  (21, 'Spearow', ARRAY['normal', 'flying'], 'Inept at flying high. However, it can fly around very fast to protect its territory.'),
  (22, 'Fearow', ARRAY['normal', 'flying'], 'A Pokémon that dates back many years. If it senses danger, it flies high and away, instantly.'),
  (23, 'Ekans', ARRAY['poison'], 'It can freely detach its jaw to swallow large prey whole. It can become too heavy to move, however.'),
  (24, 'Arbok', ARRAY['poison'], 'The pattern on its belly appears to be a frightening face. Weak foes will flee just at the sight of the pattern.'),
  (25, 'Pikachu', ARRAY['electric'], 'When it is angered, it immediately discharges the energy stored in the pouches in its cheeks.'),
  (26, 'Raichu', ARRAY['electric'], 'Its tail discharges electricity into the ground, protecting it from getting shocked.'),
  (27, 'Sandshrew', ARRAY['ground'], 'It digs deep burrows to live in. When in danger, it rolls up its body to withstand attacks.'),
  (28, 'Sandslash', ARRAY['ground'], 'It is adept at attacking with the spines on its back and its sharp claws while quickly scurrying about.'),
  (29, 'Nidoran♀', ARRAY['poison'], 'Females are more sensitive to smells than males. While foraging, they''ll use their whiskers to check wind direction and stay downwind of predators.'),
  (30, 'Nidorina', ARRAY['poison'], 'The horn on its head has atrophied. It''s thought that this happens so Nidorina''s children won''t get poked while their mother is feeding them.'),
  (31, 'Nidoqueen', ARRAY['poison', 'ground'], 'Nidoqueen is better at defense than offense. With scales like armor, this Pokémon will shield its children from any kind of attack.'),
  (32, 'Nidoran♂', ARRAY['poison'], 'The horn on a male Nidoran''s forehead contains a powerful poison. This is a very cautious Pokémon, always straining its large ears.'),
  (33, 'Nidorino', ARRAY['poison'], 'With a horn that''s harder than diamond, this Pokémon goes around shattering boulders as it searches for a moon stone.'),
  (34, 'Nidoking', ARRAY['poison', 'ground'], 'When it goes on a rampage, it''s impossible to control. But in the presence of a Nidoqueen it''s lived with for a long time, Nidoking calms down.'),
  (35, 'Clefairy', ARRAY['fairy'], 'On nights with a full moon, Clefairy gather from all over and dance. Bathing in moonlight makes them float.'),
  (36, 'Clefable', ARRAY['fairy'], 'Said to live in quiet, remote mountains, this type of fairy has a strong aversion to being seen.'),
  (37, 'Vulpix', ARRAY['fire'], 'If it is attacked by an enemy that is stronger than itself, it feigns injury to fool the enemy and escapes.'),
  (38, 'Ninetales', ARRAY['fire'], 'Some legends claim that each of its nine tails has its own unique type of special mystical power.'),
  (39, 'Jigglypuff', ARRAY['normal', 'fairy'], 'When its huge eyes waver, it sings a mysteriously soothing melody that lulls its enemies to sleep.'),
  (40, 'Wigglytuff', ARRAY['normal', 'fairy'], 'It has a very fine fur. Take care not to make it angry, or it may inflate steadily and hit with a body slam.'),
  (41, 'Zubat', ARRAY['poison', 'flying'], 'It emits ultrasonic waves from its mouth to check its surroundings. Even in tight caves, Zubat flies around with skill.'),
  (42, 'Golbat', ARRAY['poison', 'flying'], 'It loves to drink other creatures'' blood. It''s said that if it finds others of its kind going hungry, it sometimes shares the blood it''s gathered.'),
  (43, 'Oddish', ARRAY['grass', 'poison'], 'Its scientific name is Oddium wanderus. It is said to cover distances as far as 1,000 feet when night falls, walking on its two roots.'),
  (44, 'Gloom', ARRAY['grass', 'poison'], 'The fluid that oozes from its mouth isn''t drool. It is a nectar that is used to attract prey.'),
  (45, 'Vileplume', ARRAY['grass', 'poison'], 'The bud bursts into bloom with a bang. It then starts scattering allergenic, poisonous pollen.'),
  (46, 'Paras', ARRAY['bug', 'grass'], 'Burrows under the ground to gnaw on tree roots. The mushrooms on its back absorb most of the nutrition.'),
  (47, 'Parasect', ARRAY['bug', 'grass'], 'The bug host is drained of energy by the mushroom on its back. The mushroom appears to do all the thinking.'),
  (48, 'Venonat', ARRAY['bug', 'poison'], 'Poison oozes from all over its body. It catches small bug Pokémon at night that are attracted by light.'),
  (49, 'Venomoth', ARRAY['bug', 'poison'], 'The wings are covered with dustlike scales. Every time it flaps its wings, it looses highly toxic dust.'),
  (50, 'Diglett', ARRAY['ground'], 'It lives about one yard underground, where it feeds on plant roots. It sometimes appears aboveground.'),
  (51, 'Dugtrio', ARRAY['ground'], 'Its three heads bob separately up and down to loosen the soil nearby, making it easier for it to burrow.'),
  (52, 'Meowth', ARRAY['normal'], 'All it does is sleep during the daytime. At night, it patrols its territory with its eyes aglow.'),
  (53, 'Persian', ARRAY['normal'], 'Although its fur has many admirers, it is tough to raise as a pet because of its fickle meanness.'),
  (54, 'Psyduck', ARRAY['water'], 'It is constantly wracked by a headache. When the headache turns intense, it begins using mysterious powers.'),
  (55, 'Golduck', ARRAY['water'], 'When it swims at full speed using its long, webbed limbs, its forehead somehow begins to glow.'),
  (56, 'Mankey', ARRAY['fighting'], 'It lives in groups in the treetops. If it loses sight of its group, it becomes infuriated by its loneliness.'),
  (57, 'Primeape', ARRAY['fighting'], 'It becomes wildly furious if it even senses someone looking at it. It chases anyone that meets its glare.'),
  (58, 'Growlithe', ARRAY['fire'], 'It has a brave and trustworthy nature. It fearlessly stands up to bigger and stronger foes.'),
  (59, 'Arcanine', ARRAY['fire'], 'An ancient picture scroll shows that people were captivated by its movement as it ran through prairies.'),
  (60, 'Poliwag', ARRAY['water'], 'The swirl on its belly is its insides showing through the skin. It appears more clearly after Poliwag eats.'),
  (61, 'Poliwhirl', ARRAY['water'], 'Its two legs are well developed. Even though it can live on the ground, it prefers living in water.'),
  (62, 'Poliwrath', ARRAY['water', 'fighting'], 'Although it''s skilled in a style of dynamic swimming that uses all its muscles, for some reason it lives on dry land.'),
  (63, 'Abra', ARRAY['psychic'], 'This Pokémon uses its psychic powers while it sleeps. The contents of Abra''s dreams affect the powers that the Pokémon wields.'),
  (64, 'Kadabra', ARRAY['psychic'], 'Using its psychic power, Kadabra levitates as it sleeps. It uses its springy tail as a pillow.'),
  (65, 'Alakazam', ARRAY['psychic'], 'It has an incredibly high level of intelligence. Some say that Alakazam remembers everything that ever happens to it, from birth till death.'),
  (66, 'Machop', ARRAY['fighting'], 'Its whole body is composed of muscles. Even though it''s the size of a human child, it can hurl 100 grown-ups.'),
  (67, 'Machoke', ARRAY['fighting'], 'Its muscular body is so powerful, it must wear a power-save belt to be able to regulate its motions.'),
  (68, 'Machamp', ARRAY['fighting'], 'It punches with its four arms at blinding speed. It can launch 1,000 punches in two seconds.'),
  (69, 'Bellsprout', ARRAY['grass', 'poison'], 'No matter what Bellsprout is doing, if it detects movement nearby, it will immediately react by reaching out with its thin vines.'),
  (70, 'Weepinbell', ARRAY['grass', 'poison'], 'Even though it is filled with acid, it does not melt because it also oozes a protective fluid.'),
  (71, 'Victreebel', ARRAY['grass', 'poison'], 'It lures prey into its mouth with a nectar-like aroma. The helpless prey is melted with a dissolving fluid.'),
  (72, 'Tentacool', ARRAY['water', 'poison'], 'When the tide goes out, dehydrated Tentacool can be found left behind on the shore.'),
  (73, 'Tentacruel', ARRAY['water', 'poison'], 'On the rare occasions that large outbreaks of Tentacruel occur, all fish Pokémon disappear from the surrounding sea.'),
  (74, 'Geodude', ARRAY['rock', 'ground'], 'At rest, it looks just like a rock. Carelessly stepping on it will make it swing its fists angrily.'),
  (75, 'Graveler', ARRAY['rock', 'ground'], 'A slow walker, it rolls to move. It pays no attention to any object that happens to be in its path.'),
  (76, 'Golem', ARRAY['rock', 'ground'], 'It is enclosed in a hard shell that is as rugged as slabs of rock. It sheds skin once a year to grow larger.'),
  (77, 'Ponyta', ARRAY['fire'], 'About an hour after birth, Ponyta''s fiery mane and tail grow out, giving the Pokémon an impressive appearance.'),
  (78, 'Rapidash', ARRAY['fire'], 'It gallops at nearly 150 mph. With its mane blazing ferociously, it races as if it were an arrow.'),
  (79, 'Slowpoke', ARRAY['water', 'psychic'], 'It is incredibly slow and dopey. It takes five seconds for it to feel pain when under attack.'),
  (80, 'Slowbro', ARRAY['water', 'psychic'], 'When a Slowpoke went hunting in the sea, its tail was bitten by a Shellder. That made it evolve into Slowbro.'),
  (81, 'Magnemite', ARRAY['electric', 'steel'], 'The electromagnetic waves emitted by the units at the sides of its head expel antigravity, which allows it to float.'),
  (82, 'Magneton', ARRAY['electric', 'steel'], 'Three Magnemite are linked by a strong magnetic force. Earaches will occur if you get too close.'),
  (83, 'Farfetch''d', ARRAY['normal', 'flying'], 'It can''t live without the stalk it holds. That''s why it defends the stalk from attackers with its life.'),
  (84, 'Doduo', ARRAY['normal', 'flying'], 'Its twin heads have exactly the same genes and battle in perfect sync with each other.'),
  (85, 'Dodrio', ARRAY['normal', 'flying'], 'It now has three hearts and three sets of lungs. Though it can''t run as fast as Doduo, Dodrio can keep running for longer stretches of time.'),
  (86, 'Seel', ARRAY['water'], 'The protrusion on its head is very hard. It is used for bashing through thick ice.'),
  (87, 'Dewgong', ARRAY['water', 'ice'], 'It sleeps under shallow ocean waters during the day, then looks for food at night when it''s colder.'),
  (88, 'Grimer', ARRAY['poison'], 'Born from sludge, these Pokémon now gather in polluted places and increase the bacteria in their bodies.'),
  (89, 'Muk', ARRAY['poison'], 'It''s thickly covered with a filthy, vile sludge. It is so toxic, even its footprints contain poison.'),
  (90, 'Shellder', ARRAY['water'], 'It is encased in a shell that is harder than diamond. Inside, however, it is surprisingly tender.'),
  (91, 'Cloyster', ARRAY['water', 'ice'], 'Cloyster that live in seas with harsh tidal currents grow large, sharp spikes on their shells.'),
  (92, 'Gastly', ARRAY['ghost', 'poison'], 'It wraps its opponent in its gas-like body, slowly weakening its prey by poisoning it through the skin.'),
  (93, 'Haunter', ARRAY['ghost', 'poison'], 'It likes to lurk in the dark and tap shoulders with a gaseous hand. Its touch causes endless shuddering.'),
  (94, 'Gengar', ARRAY['ghost', 'poison'], 'To steal the life of its target, it slips into the prey''s shadow and silently waits for an opportunity.'),
  (95, 'Onix', ARRAY['rock', 'ground'], 'As it digs through the ground, it absorbs many hard objects. This is what makes its body so solid.'),
  (96, 'Drowzee', ARRAY['psychic'], 'It remembers every dream it eats. It rarely eats the dreams of adults because children''s are much tastier.'),
  (97, 'Hypno', ARRAY['psychic'], 'When it locks eyes with an enemy, it will use a mix of psi moves, such as Hypnosis and Confusion.'),
  (98, 'Krabby', ARRAY['water'], 'It can be found near the sea. The large pincers grow back if they are torn out of their sockets.'),
  (99, 'Kingler', ARRAY['water'], 'The larger pincer has 10,000-horsepower strength. However, it is so heavy, it is difficult to aim.'),
  (100, 'Voltorb', ARRAY['electric'], 'It rolls to move. If the ground is uneven, a sudden jolt from hitting a bump can cause it to explode.'),
  (101, 'Electrode', ARRAY['electric'], 'The more energy it charges up, the faster it gets. But this also makes it more likely to explode.'),
  (102, 'Exeggcute', ARRAY['grass', 'psychic'], 'If you touch one of Exeggcute''s heads, mistaking it for an egg, the other heads will quickly gather and attack you in a swarm.'),
  (103, 'Exeggutor', ARRAY['grass', 'psychic'], 'It is called the Walking Jungle. Each of the nuts has a face and a will of its own.'),
  (104, 'Cubone', ARRAY['ground'], 'When the memory of its departed mother brings it to tears, its cries echo mournfully within the skull it wears on its head.'),
  (105, 'Marowak', ARRAY['ground'], 'This Pokémon overcame its sorrow to evolve a sturdy new body. Marowak faces its opponents bravely, using a bone as a weapon.'),
  (106, 'Hitmonlee', ARRAY['fighting'], 'At the exact moment it lands a kick on its target, Hitmonlee hardens the muscles on the sole of its foot, maximizing the power of the kick.'),
  (107, 'Hitmonchan', ARRAY['fighting'], 'It corners its foes with combo punches from both sides, then finishes them off with a single straight punch launched at over 300 mph.'),
  (108, 'Lickitung', ARRAY['normal'], 'If this Pokémon''s sticky saliva gets on you and you don''t clean it off, an intense itch will set in. The itch won''t go away, either.'),
  (109, 'Koffing', ARRAY['poison'], 'Toxic gas is held within its thin, balloon-shaped body, so it can cause massive explosions.'),
  (110, 'Weezing', ARRAY['poison'], 'Top-grade perfume is made using its internal poison gases by diluting them to the highest level.'),
  (111, 'Rhyhorn', ARRAY['ground', 'rock'], 'Rhyhorn claims an area with over a six mile radius as its territory. It apparently forgets where this territory is when running, however.'),
  (112, 'Rhydon', ARRAY['ground', 'rock'], 'The horn of a Rhydon is powerful enough to crush raw diamonds. These Pokémon polish their horns by bashing them together.'),
  (113, 'Chansey', ARRAY['normal'], 'This kindly Pokémon lays highly nutritious eggs and shares them with injured Pokémon or people.'),
  (114, 'Tangela', ARRAY['grass'], 'Hidden beneath a tangle of vines that grows nonstop even if the vines are torn off, this Pokémon''s true appearance remains a mystery.'),
  (115, 'Kangaskhan', ARRAY['normal'], 'Although it''s carrying its baby in a pouch on its belly, Kangaskhan is swift on its feet. It intimidates its opponents with quick jabs.'),
  (116, 'Horsea', ARRAY['water'], 'If attacked—even by a large enemy—Horsea effortlessly swims to safety by utilizing its well-developed dorsal fin.'),
  (117, 'Seadra', ARRAY['water'], 'The male raises the young. If it is approached while caring for young, it will use its toxic spines to fend off the intruder.'),
  (118, 'Goldeen', ARRAY['water'], 'Its dorsal, pectoral, and tail fins wave elegantly in water. That is why it is known as the Water Dancer.'),
  (119, 'Seaking', ARRAY['water'], 'In autumn, its body becomes more fatty in preparing to propose to a mate. It takes on beautiful colors.'),
  (120, 'Staryu', ARRAY['water'], 'If you visit a beach at the end of summer, you''ll be able to see groups of Staryu lighting up in a steady rhythm.'),
  (121, 'Starmie', ARRAY['water', 'psychic'], 'This Pokémon has an organ known as its core. The organ glows in seven colors when Starmie is unleashing its potent psychic powers.'),
  (122, 'Mr. Mime', ARRAY['psychic', 'fairy'], 'It is a pantomime expert that can create invisible but solid walls using miming gestures.'),
  (123, 'Scyther', ARRAY['bug', 'flying'], 'It slashes through grass with its sharp scythes, moving too fast for the human eye to track.'),
  (124, 'Jynx', ARRAY['ice', 'psychic'], 'In certain parts of Galar, Jynx was once feared and worshiped as the Queen of Ice.'),
  (125, 'Electabuzz', ARRAY['electric'], 'Its body constantly discharges electricity. Getting close to it will make your hair stand on end.'),
  (126, 'Magmar', ARRAY['fire'], 'Found near the mouth of a volcano. This fire-breather''s body temperature is nearly 2,200 degrees Fahrenheit.'),
  (127, 'Pinsir', ARRAY['bug'], 'These Pokémon judge one another based on pincers. Thicker, more impressive pincers make for more popularity with the opposite gender.'),
  (128, 'Tauros', ARRAY['normal'], 'When it targets an enemy, it charges furiously while whipping its body with its long tails.'),
  (129, 'Magikarp', ARRAY['water'], 'An underpowered, pathetic Pokémon. It may jump high on rare occasions but never more than seven feet.'),
  (130, 'Gyarados', ARRAY['water', 'flying'], 'Once it appears, it goes on a rampage. It remains enraged until it demolishes everything around it.'),
  (131, 'Lapras', ARRAY['water', 'ice'], 'It ferries people across the sea on its back. It may sing an enchanting cry if it is in a good mood.'),
  (132, 'Ditto', ARRAY['normal'], 'Its transformation ability is perfect. However, if made to laugh, it can''t maintain its disguise.'),
  (133, 'Eevee', ARRAY['normal'], 'Its ability to evolve into many forms allows it to adapt smoothly and perfectly to any environment.'),
  (134, 'Vaporeon', ARRAY['water'], 'It lives close to water. Its long tail is ridged with a fin, which is often mistaken for a mermaid''s.'),
  (135, 'Jolteon', ARRAY['electric'], 'It concentrates the weak electric charges emitted by its cells and launches wicked lightning bolts.'),
  (136, 'Flareon', ARRAY['fire'], 'Inhaled air is carried to its flame sac, heated, and exhaled as fire that reaches over 3,000 degrees Fahrenheit.'),
  (137, 'Porygon', ARRAY['normal'], 'It is an artificial Pokémon. Since it doesn''t breathe, people are excited by its potential to be useful in any environment.'),
  (138, 'Omanyte', ARRAY['rock', 'water'], 'Because some Omanyte manage to escape after being restored or are released into the wild by people, this species is becoming a problem.'),
  (139, 'Omastar', ARRAY['rock', 'water'], 'Weighed down by a large and heavy shell, Omastar couldn''t move very fast. Some say it went extinct because it was unable to catch food.'),
  (140, 'Kabuto', ARRAY['rock', 'water'], 'This species is almost entirely extinct. Kabuto molt every three days, making their shells harder and harder.'),
  (141, 'Kabutops', ARRAY['rock', 'water'], 'Kabutops slices its prey apart and sucks out the fluids. The discarded body parts become food for other Pokémon.'),
  (142, 'Aerodactyl', ARRAY['rock', 'flying'], 'This is a ferocious Pokémon from ancient times. Apparently even modern technology is incapable of producing a perfectly restored specimen.'),
  (143, 'Snorlax', ARRAY['normal'], 'This gluttonous Pokémon eats constantly, apart from when it''s asleep. It devours nearly 900 pounds of food per day.'),
  (144, 'Articuno', ARRAY['ice', 'flying'], 'This legendary bird Pokémon can create blizzards by freezing moisture in the air.'),
  (145, 'Zapdos', ARRAY['electric', 'flying'], 'This legendary Pokémon is said to live in thunderclouds. It freely controls lightning bolts.'),
  (146, 'Moltres', ARRAY['fire', 'flying'], 'It is one of the legendary bird Pokémon. Its appearance is said to indicate the coming of spring.'),
  (147, 'Dratini', ARRAY['dragon'], 'It sheds many layers of skin as it grows larger. During this process, it is protected by a rapid waterfall.'),
  (148, 'Dragonair', ARRAY['dragon'], 'They say that if it emits an aura from its whole body, the weather will begin to change instantly.'),
  (149, 'Dragonite', ARRAY['dragon', 'flying'], 'It is said that somewhere in the ocean lies an island where these gather. Only they live there.'),
  (150, 'Mewtwo', ARRAY['psychic'], 'Its DNA is almost the same as Mew''s. However, its size and disposition are vastly different.'),
  (151, 'Mew', ARRAY['psychic'], 'When viewed through a microscope, this Pokémon''s short, fine, delicate hair can be seen.')
) AS new_pokemon (id, name, types, description)
WHERE NOT EXISTS (
  SELECT 1 FROM pokemon p 
  WHERE p.id = new_pokemon.id
);