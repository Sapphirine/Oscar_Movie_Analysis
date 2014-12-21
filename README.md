Oscar_Movie_Analysis
====================
The software packages in our project are consist of three parts: java programs for processing Amazon dataset to prepare for clustering; cluster-movies.sh shell file for clustering Amazon dataset; and the Pig scripts for processing Yahoo dataset.
For the java programs, three java programs named Parse.java, Modify.java and Replace.java.
Parse.java works as a parser to get the movie reviews of whole dataset.
Replace.java will scan these reviews and remove those insignificant words for our expected results such as “he”, “she”, “is” etc.
Modify.java is going to parse the result file and get each review to a single .txt file.
For the cluster-movies.sh shell file, it is modified from cluster-reuters.sh, which is contained in examples in Mahout. By running it we can get movies dataset and prepares it for clustering, then cluster the dataset using any of these four algorithms: k-means, fussy k-means, lda and streaming k- means. In our project, after trying all these algorithms, we found the best algorithm for our project is k-means.
