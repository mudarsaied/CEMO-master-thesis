library(Orcs)
setwdOS(
    lin = "~/", win = Sys.getenv("USERPROFILE")
)

library(intsvy)
mydata <- pisa.select.merge(
    student.file = "CY07_MSU_STU_QQQ.sav",
    school.file = "CY07_MSU_SCH_QQQ.sav",
    student = c(
        #CONTROL VARIABLES
        "ST004D01T", # Student sex
        "IMMIG", #Immigration
        "ESCS", #index socioeconomic status
        #X1 ACCESSIBILITY
        "ICTHOME",#ICT available at home #6
        "ICTSCH", #ICT available at school #14
        "ICTRES", #ICT resources #6
        #X2 ENGAGEMENT
        #X2.1 ICT INTEREST
        "INTICT", #Interest in ICT (WLE) #9
        #X2.2 PERCEIVED ICT COMPETENCE
        "COMPICT", #Perceived ICT competence (WLE) #9
        #X2.3 PERCEIVED ICT AUTONOMY
        "AUTICT", #Perceived ICT autonomy(WLE) #9
        #X2.4 ICT as a TOPIC of SOCIAL INTERACTION
        "SOIAICT", #ICT as a topic of social interaction (WLE) #9
        #X3 USE
        #X3.1 ENTERTAINMENT AT HOME
        "ENTUSE", #ICT use outside school for leisure #9
        "IC008Q01TA", #Playing one-player games.
        "IC008Q02TA", #Playing collaborative online games.
        "IC008Q04TA", #Chatting online
        "IC008Q05TA", #Participating in Social Networks e.g. Facebook
        "IC008Q08TA", #Browsing the Internet for fun (watching Youtube)
        #3.2 PRACTICAL USE  AT HOME
        "IC008Q03TA", #Using email
        "IC008Q09TA", #Reading news on the internet
        "IC008Q10TA", #Obtaining practical information from the Internet
        # 3.3 ACADEMIC USE AT SCHOOL
        "IC011Q03TA",
        "IC011Q04TA",
        "IC011Q05TA",
        "IC011Q07TA",
        "IC011Q08TA",
        "IC011Q09TA",
        "IC011Q10HA",
        # 3.4 NON-ACADEMIC USE AT SCHOOL
        "IC011Q01TA",
        "IC011Q02TA",
        "IC011Q06TA",
        #X3.5 SCHOOL-RELATED USE AT HOME
        "HOMESCH", #Use of ICT outside school for schoolwork #9
        #X3.6 USE AT SCHOOL
        "USESCH", #Use of ICT at school in general #9
        #MEDIATION
        #M1,2,3
        "JOYREAD", #Enjoy, like reading
        "SCREADCOMP", #Self-concept of reading: Perception of competence (WLE)
        "SCREADDIFF" # Self-concept of reading: Perception of difficulty (WLE)
    ),
    school = c(
        #SX1 SCHOOL CAPACITY USING DIGITAL DEVICES
        "RATCMP1", #Number of available computers per student at modal grade
        "RATCMP2", #Proportion of available computers connected to the Internet
        #SX2 POLICY
        "SC156Q01HA", #Its own written statement about the use of DD
        "SC156Q02HA", #Its own ## specifically abt use DD 4 pedagogical purpose
        "SC156Q05HA", #Spcfc prgramm 2prepare students 4 rspnsbl Intrnt behavior
        "SC156Q06HA", #Specfc polcy abt using Social Networks (<Facebook>) in teaching and learning
        "SC156Q03HA", # A program to use DD for teaching&learning in specific subjects
        "SC156Q04HA" #Regular discussions with teaching staff abt DD use 4 pedagogical purposes
    ),
    countries = c("FIN", "DNK", "SWE")
)

library(data.table)
setDTthreads(0)
fwrite(mydata, file = "ict.dat", sep = "\t", row.names = F, col.names = T)
