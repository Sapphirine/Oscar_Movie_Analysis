Oscar_Movie_Analysis
====================
The software packages in our project are consist of three parts: java programs for processing Amazon dataset to prepare for clustering; cluster-movies.sh shell file for clustering Amazon dataset; and the Pig scripts for processing Yahoo dataset.
For the java programs, three java programs named Parse.java, Modify.java and Replace.java.
Parse.java works as a parser to get the movie reviews of whole dataset.
Replace.java will scan these reviews and remove those insignificant words for our expected results such as “he”, “she”, “is” etc.
Modify.java is going to parse the result file and get each review to a single .txt file.
For the cluster-movies.sh shell file, it is modified from cluster-reuters.sh, which is contained in examples in Mahout. By running it we can get movies dataset and prepares it for clustering, then cluster the dataset using any of these four algorithms: k-means, fussy k-means, lda and streaming k- means. In our project, after trying all these algorithms, we found the best algorithm for our project is k-means.

For the Pig scripts, there are two scripts, one is for analyze the age distribution, the other is for gender distribution.
Age distribution
• Download Pig
• export PATH=/<my-path-to-pig>/pig-
n.n.n/bin:$PATH
• Make sure that your JAVA_HOME has been
correctly set.
• Run your pig code in local mode
pig -x local
• Replace “PATH-TO-dataset” with your own. The
datasets include ratings.csv, ydata-ymovies-
mapping-to-eachmovie-v1_0.txt and user_data.txt. • Follow the order of the code and the comment, type
them into the terminal one by one.
• Replace “PATH-TO-19X0s” with your own path and
this is used to store the result of the ranking list of movies of a certain generation.
Gender distribution
• Download pig.
• export PATH=/<my-path-to-pig>/pig-
n.n.n/bin:$PATH
• Make sure that your JAVA_HOME has been
correctly set.
• Run your pig code in local mode
pig -x local
• Replace “PATH-TO-dataset” with your own. The
datasets include ratings.csv, ydata-ymovies-
mapping-to-eachmovie-v1_0.txt and user_data.txt. • Follow the order of the code and the comment, type
them into the terminal one by one.
• Replace “PATH-TO-male_results” and “PATH-TO-
female_results” with your own path and this is used to store the result of the ranking list of movies of males and females.
