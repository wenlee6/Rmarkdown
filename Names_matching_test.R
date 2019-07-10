
brightline_tt<-analysis_dataset %>% group_by(IRD_NUMBER) %>% summarise(count=n())


##Reading in test dataset
namesfull<-read.csv('names_test_dataset.csv',header=T)
names_only<-namesfull %>%select(fstrAdditionalInfo) %>% unique() %>%rename(name=fstrAdditionalInfo)
names_wo_commas <-gsub("\\,","",names_only$name)
names_upper<-toupper(names_wo_commas)



##KERMANI PROPERTIES LIMITED, KEMINA PROPERTIES LIMITED, KERMANI GROUP LIMITED


names_chosen <-toupper(c("Son Thanh Nguyen","FLETCHER RESIDENTIAL LIMITED","Kermani Properties Limited"))
names_taken <-names_upper

#library(RecordLinkage)
library(stringdist)
library(dplyr)

ref <- c('cat', 'dog', 'turtle', 'cow', 'horse', 'pig', 'sheep', 'koala','bear','fish')
words <- c('dog', 'kiwi', 'emu', 'pig', 'sheep', 'cow','cat','horse')

wordlist <- expand.grid(words = names_chosen, ref = names_taken, stringsAsFactors = FALSE)

system.time(matched<- wordlist %>% group_by(words) %>% mutate(match_score = levenshteinSim(words, ref)) %>%
  summarise(match = match_score[which.max(match_score)], matched_to = ref[which.max(match_score)]))
check2<-matched %>%filter(words=='BICKFORD LANCE GEORGE')

#levenshteinSim - Takes longer but bteer than JaroWinkler (slightly)

#jarowinkler - Best used with names - fastest - but still problematic

#hamming - takes the longest


library(stringdist)

system.time(matched<- wordlist %>% group_by(words) %>% mutate(match_score = stringdist(words, ref,method="hamming")) %>%
              summarise(match = match_score[which.min(match_score)], matched_to = ref[which.min(match_score)]))

check<-matched %>% filter(match<2)
check<-matched %>%filter(words=='BICKFORD LANCE GEORGE')


system.time(matched<- wordlist %>% group_by(words) %>% mutate(match_score = jarowinkler(words, ref)) %>% arrange(desc(match_score))
            
            