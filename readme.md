
This is work in progress...

# 1. Intro

Our aim is to develop a tookbox that can be used to explore how we segment the speech stream into segments before we attempt to recognize acoustic events and higher-level phonetic units. We believe expect that clarifying this issue might be valuable to address research questions in various areas (and we hope that the toolbox will be useful for whoever is interested in answering these questions):

1. Related with language acquisition:
   * do children / adults segment speech identically or as Nittrouer and colleagues have proposed children use larger segments (see Nittrouer, 2004)?

2. Related with clinical linguistics:
   * are segmentation strategies disrupted in speech and language processing pathologies?
   * if the answer to the above question is yes, are segmentation errors the source or the consequence of other speech processing problems?
   * do cochlear implant and normally hearing listeners segment speech identically (see Moreno-Torres & Sonia-Madrid, in review)?

3. Language variation
   * do speakers from different dialects/languages segment speech identically?
   * do speakers segment speech identically in all circumstances?
   * is language change related with speech segmentation?



# 2. Basic structure of the system and flowchart

The system has two main components:
 * A set of speech segmenters
 * A set of segmenter evaluators

The speech segmenters include (to date: 2nd Jun 18)
  * Lee and Cho (2016) brain inspired algorithm
  * A fixed frame segmenter

The segmenters evaluator should quantify to what extent a specific segmentation is
successful. The  evaluator implemented to date: 2nd Jun 18) is:
   * Euclidean distance (as used by Lee and Cho, 2016).

We expect to add more segmenters and evaluators if the authorities
provide funding to pay our Matlab programmer.

This is the basic flowchart of the program (Salvador):

# 3. Contact

Feel free to contact us if you would like to collaborate with us
caliope@uma.es


# References
Lee, B., & Cho, K.-H. (2016). Brain-inspired speech segmentation for automatic speech recognition using the speech envelope as a temporal reference. Scientific Reports, 6, 37647.

Moreno-Torres, I., & Madrid C?novas, S. (in review). Recognition of Spanish consonants in 8-talker babble by children with cochlear implants, and by children and adults with normal hearing. J. Acoust. Soc. Am.

Nittrouer, S., (2004). The role of temporal and dynamic signal components in the perception of syllable-final stop voicing by children and adults. J. Acoust. Soc. Am. 115(4): 1777-1790.
