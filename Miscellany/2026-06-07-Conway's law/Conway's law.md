---
title: "Conway's law"
source: "https://en.wikipedia.org/wiki/Conway%27s_law"
author:
  - "[[Wikipedia]]"
published: 2005-07-22
created: 2026-06-07
description:
tags:
  - "ToRead"
---
**Conway's law** describes the link between communication structure of organizations and the systems they design. It is named after the computer scientist and programmer [Melvin Conway](https://en.wikipedia.org/wiki/Melvin_Conway "Melvin Conway"), who introduced the idea in 1967.[^1] His original wording was:[^2] [^3]

> \[O\]rganizations which design systems (in the broad sense used here) are constrained to produce designs which are copies of the communication structures of these organizations.

— Melvin E. Conway, How Do Committees Invent?

The law is based on the reasoning that in order for a product to function, the authors and designers of its component parts must communicate with each other in order to ensure compatibility between the components. Therefore, the technical structure of a system will reflect the social boundaries of the organizations that produced it, across which communication is more difficult. In colloquial terms, it means complex products end up "shaped like" the organizational structure they are designed in or designed for. The law is applied primarily in the field of software architecture, though Conway directed it more broadly and its assumptions and conclusions apply to most technical fields.

## Interpretations

The law is, in a strict sense, only about correspondence; it does *not* state that communication structure is the cause of system structure, merely describes the connection. Different commentators have taken various positions on the direction of causality; that technical design causes the organization to restructure to fit,[^4] that the organizational structure dictates the technical design,[^5] or both.[^6] [^7] [^8] Conway's law was intended originally as a sociological observation, but many other interpretations are possible. The *New Hacker's Dictionary* entry uses it in a primarily humorous context,[^9] while participants at the 1968 *National Symposium on [Modular Programming](https://en.wikipedia.org/wiki/Modular_programming "Modular programming")* considered it sufficiently serious and universal to dub it 'Conway's Law'.[^10] Opinions also vary on the desirability of the phenomenon; some say that the mirroring pattern is a helpful feature of such systems, while other interpretations say it's an undesirable result of organizational bias. Middle positions describe it as a necessary feature of compromise, undesirable in the abstract but necessary to handle human limitations.[^11]

## Examples

Nigel Bevan stated in a 1997 paper, regarding [usability](https://en.wikipedia.org/wiki/Usability "Usability") issues in websites: "Organizations often produce web sites with a content and structure which mirrors the internal concerns of the organization rather than the needs of the users of the site." [^12]

Evidence in support of Conway's law has been published by a team of [Massachusetts Institute of Technology](https://en.wikipedia.org/wiki/Massachusetts_Institute_of_Technology "Massachusetts Institute of Technology") (MIT) and [Harvard Business School](https://en.wikipedia.org/wiki/Harvard_Business_School "Harvard Business School") researchers who, using "the mirroring hypothesis" as an equivalent term for Conway's law, found "strong evidence to support the mirroring hypothesis", and that the "product developed by the loosely-coupled organization is significantly more modular than the product from the tightly-coupled organization". The authors highlight the impact of "organizational design decisions on the technical structure of the artifacts that these organizations subsequently develop".[^13]

Additional and likewise supportive case studies of Conway's law have been conducted by Nagappan, Murphy and Basili at the [University of Maryland](https://en.wikipedia.org/wiki/University_of_Maryland "University of Maryland") in collaboration with [Microsoft](https://en.wikipedia.org/wiki/Microsoft "Microsoft"),[^14] and by Syeed and Hammouda at [Tampere University of Technology](https://en.wikipedia.org/wiki/Tampere_University_of_Technology "Tampere University of Technology") in Finland.[^15]

## Variations

[Edward Yourdon](https://en.wikipedia.org/wiki/Edward_Yourdon "Edward Yourdon") and [Larry Constantine](https://en.wikipedia.org/wiki/Larry_Constantine "Larry Constantine"), in their 1979 book on [Structured Design](https://en.wikipedia.org/wiki/Structured_Design "Structured Design"), gave a more strongly stated variation of Conway's Law:[^10]

> The structure of any system designed by an organization is [isomorphic](https://en.wikipedia.org/wiki/Isomorphism "Isomorphism") to the structure of the organization.

[James O. Coplien](https://en.wikipedia.org/wiki/James_O._Coplien "James O. Coplien") and [Neil B. Harrison](https://en.wikipedia.org/w/index.php?title=Neil_B._Harrison&action=edit&redlink=1 "Neil B. Harrison (page does not exist)") stated in a 2004 book concerned with organizational patterns of [agile software development](https://en.wikipedia.org/wiki/Agile_software_development "Agile software development"):[^16]

> If the parts of an organization (e.g., teams, departments, or subdivisions) do not closely reflect the essential parts of the product, or if the relationships between organizations do not reflect the relationships between product parts, then the project will be in trouble... Therefore: Make sure the organization is compatible with the product architecture.

[^1]: Conway, Melvin. ["Conway's Law"](http://www.melconway.com/Home/Conways_Law.html). *Mel Conway's Home Page*. [Archived](https://web.archive.org/web/20190929004831/http://www.melconway.com/Home/Conways_Law.html) from the original on 2019-09-29. Retrieved 2019-09-29.

[^2]: Conway, Melvin E. (April 1968). ["How do Committees Invent?"](http://www.melconway.com/Home/Committees_Paper.html). *[Datamation](https://en.wikipedia.org/wiki/Datamation "Datamation")*. **14** (5): 28–31. [Archived](https://web.archive.org/web/20191010021833/http://www.melconway.com/Home/Committees_Paper.html) from the original on 2019-10-10. Retrieved 2019-10-10. \[…\] organizations which design systems \[…\] are constrained to produce designs which are copies of the communication structures of these organizations.

[^3]: Conway, Melvin (1968). ["How do committees invent"](http://www.melconway.com/Home/pdf/committees.pdf) (PDF). *Datamation*: 28–31.

[^4]: Chandler, A. D. (1977). The Visible Hand: The Managerial Revolution in American Business. Harvard University Press, Cambridge, MA.

[^5]: Henderson, R. M., & Clark, K. B. (1990). Architectural innovation: The reconfiguration of existing product technologies and the failure of established firms. Administrative science quarterly, 9-30.

[^6]: Baldwin, C. Y., & Clark, K. B. (2000). Design rules: The power of modularity (Vol. 1). Chapter 7. MIT press. (Chapters 1 and 14 are counted as a descriptive industry study.)

[^7]: Fixson, S. K., & Park, J. K. (2008). The power of integrality: Linkages between product architecture, innovation, and industry structure. Research Policy, 37(8), 1296-1316.

[^8]: "The Mirroring Hypothesis: Theory, Evidence and Exceptions", Lyra J. Colfer, Carliss Y. Baldwin [https://www.hbs.edu/ris/Publication%20Files/16-124\_7ae90679-0ce6-4d72-9e9d-828872c7af49.pdf](https://www.hbs.edu/ris/Publication%20Files/16-124_7ae90679-0ce6-4d72-9e9d-828872c7af49.pdf)

[^9]: Raymond1996

[^10]: Yourdon, Edward; Constantine, Larry L. (1979). [*Structured Design: Fundamentals of a Discipline of Computer Program and Systems Design*](https://books.google.com/books?id=zMQmAAAAMAAJ) (2nd ed.). Englewood Cliffs, N.J.: Prentice Hall. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [0138544719](https://en.wikipedia.org/wiki/Special:BookSources/0138544719 "Special:BookSources/0138544719"). [OCLC](https://en.wikipedia.org/wiki/OCLC_\(identifier\) "OCLC (identifier)") [4503223](https://search.worldcat.org/oclc/4503223). Conway's Law: The structure of a system reflects the structure of the organization that built it. Conway's Law has been stated even more strongly: The structure of any system designed by an organization is isomorphic to the structure of the organization.

[^11]: [Muratori, Casey](https://en.wikipedia.org/wiki/Casey_Muratori "Casey Muratori") (15 March 2022), [*The Only Unbreakable Law*](https://www.youtube.com/watch?v=5IUj1EZwpJY), retrieved 2022-03-21

[^12]: Bevan, Nigel (November 1997). ["Usability issues in website design"](https://experiencelab.typepad.com/files/usability-issues-in-website-design-1.pdf) (PDF). *Design of Computing Systems: Social and Ergonomic Considerations*. Proceedings of the Seventh International Conference on Human-Computer Interaction (HCI International '97). Vol. 2. San Francisco, California, USA: Elsevier. pp. 803–806.

[^13]: MacCormack, Alan; Rusnak, John; Baldwin, Carliss Y. (2011). ["Exploring the Duality between Product and Organizational Architectures: A Test of the Mirroring Hypothesis"](https://dash.harvard.edu/bitstream/handle/1/34403525/maccormack%2Cbaldwin%2Crusnak_exploring-the-duality.pdf) (PDF). *SSRN Working Paper Series*. [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\) "Doi (identifier)"):[10.2139/ssrn.1104745](https://doi.org/10.2139%2Fssrn.1104745). [ISSN](https://en.wikipedia.org/wiki/ISSN_\(identifier\) "ISSN (identifier)") [1556-5068](https://search.worldcat.org/issn/1556-5068). [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\) "S2CID (identifier)") [16097528](https://api.semanticscholar.org/CorpusID:16097528). We find strong evidence to support the mirroring hypothesis. In all of the pairs we examine, the product developed by the loosely-coupled organization is significantly more modular than the product from the tightly-coupled organization. \[…\] Our results have significant managerial implications, in highlighting the impact of organizational design decisions on the technical structure of the artifacts that these organizations subsequently develop.

[^14]: Nagappan, Nachiappan; Murphy, Brendan; Basili, Victor (2008). "The influence of organizational structure on software quality: An empirical case study". *Proceedings of the 13th international conference on Software engineering - ICSE '08*. New York, New York, USA: ACM Press. p. 521. [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\) "Doi (identifier)"):[10.1145/1368088.1368160](https://doi.org/10.1145%2F1368088.1368160). [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [9781605580791](https://en.wikipedia.org/wiki/Special:BookSources/9781605580791 "Special:BookSources/9781605580791"). [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\) "S2CID (identifier)") [5048618](https://api.semanticscholar.org/CorpusID:5048618).

[^15]: Syeed, M. M. Mahbubul; Hammouda, Imed (2013). "Socio-technical Congruence in OSS Projects: Exploring Conway's Law in FreeBSD". *Open Source Software: Quality Verification*. IFIP Advances in Information and Communication Technology. Vol. 404. pp. 109–126. [doi](https://en.wikipedia.org/wiki/Doi_\(identifier\) "Doi (identifier)"):[10.1007/978-3-642-38928-3\_8](https://doi.org/10.1007%2F978-3-642-38928-3_8). [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [978-3-642-38927-6](https://en.wikipedia.org/wiki/Special:BookSources/978-3-642-38927-6 "Special:BookSources/978-3-642-38927-6"). [S2CID](https://en.wikipedia.org/wiki/S2CID_\(identifier\) "S2CID (identifier)") [39852208](https://api.semanticscholar.org/CorpusID:39852208).

[^16]: Coplien and Harrison (July 2004). *Organizational Patterns of Agile Software Development*. Pearson Prentice Hall. [ISBN](https://en.wikipedia.org/wiki/ISBN_\(identifier\) "ISBN (identifier)") [978-0-13-146740-8](https://en.wikipedia.org/wiki/Special:BookSources/978-0-13-146740-8 "Special:BookSources/978-0-13-146740-8").