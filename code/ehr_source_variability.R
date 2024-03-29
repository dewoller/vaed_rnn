library("PCAmixdata")
# We are going to estimate the MSV metrics and plot an MSV plot of the three first PCA coordinates of a dataset con
# We assume 'data' is a data.frame including numerical and categorical variables
# We get the indices of numerical and categorical data
quantidx = sapply(data,class) %in% c("numeric","integer")
qualiidx = sapply(data,class) %in% c("factor","character")
# We estimate a PCA projection using PCAmix for both numerical and categorical data
mca = PCAmix(X.quanti = NULL, X.quali = datasetVarsC2, ndim = 3, rename.level = TRUE, graph = FALSE)
  coords = mca$ind$coord
# 'ID_SOURCE' contains the data source tag for each row in the data
# We get a kernel density estimation for the distributions of each source, removing those NULL estimations next
  kdeData = by(coords[,1],ID_SOURCE, density, n = 100, from = min(coords[,1]), to = max(coords[,1]))
  kdeData = lapply(kdeData,function(x) x$y)
kdeNull = sapply(kdeData,is.null)
  kdeNotNull = kdeData[!kdeNull]
kdeDataNotNull = matrix(unlist(kdeNotNull), ncol = length(kdeNotNull), byrow = FALSE)
  probMatrix = sweep(kdeDataNotNull, 2, colSums(kdeDataNotNull), FUN="/")
# We estimate the MSV metrics
  msvMetrics = estimateMSVmetrics(probMatrix)
  idSource = levels(ID_SOURCE)
  nBySource = table(ID_SOURCE)
plotMSV(msvMetrics, nBySource, idSource)
