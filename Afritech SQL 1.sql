
CREATE TABLE Afritech(
CustomerID INT,
CustomerName TEXT,	
Region TEXT,	
Age INT,	
Income NUMERIC,	
CustomerType TEXT,	
TransactionYear INT,	
TransactionDate DATE,	
ProductPurchased TEXT,	
PurchaseAmount NUMERIC,	
ProductRecalled BOOLEAN,	
Competitor_x TEXT,	
InteractionDate DATE,
Platform TEXT,
PostType TEXT,
EngagementLikes INT,
EngagementShares INT,
EngagementComments INT,
UserFollowers INT,
InfluencerScore NUMERIC,
BrandMention BOOLEAN,
CompetitorMention BOOLEAN,
Sentiment TEXT,
CrisisEventTime DATE,
FirstResponseTime DATE,
ResolutionStatus BOOLEAN,
NPSResponse INT
)

SELECT * 
FROM Afritech


CREATE TABLE CustomerData(
CustomerID INT PRIMARY KEY,
CustomerName TEXT,	
Region TEXT,	
Age INT,	
Income NUMERIC,	
CustomerType TEXT
)

CREATE TABLE TransactionData(
Transationid SERIAL PRIMARY KEY,
CustomerID INT,
TransactionYear INT,	
TransactionDate DATE,	
ProductPurchased TEXT,	
PurchaseAmount NUMERIC,	
ProductRecalled BOOLEAN,
FOREIGN KEY (CustomerID) REFERENCES CustomerData
)


CREATE TABLE SocialMedia(
PostID SERIAL PRIMARY KEY,
CustomerID INT,
Competitor_x TEXT,	
InteractionDate DATE,
Platform TEXT,
PostType TEXT,
EngagementLikes INT,
EngagementShares INT,
EngagementComments INT,
UserFollowers INT,
InfluencerScore NUMERIC,
BrandMention BOOLEAN,
CompetitorMention BOOLEAN,
Sentiment TEXT,
CrisisEventTime DATE,
FirstResponseTime DATE,
ResolutionStatus BOOLEAN,
NPSResponse INT,
FOREIGN KEY (CustomerID) REFERENCES CustomerData
)

SELECT *
FROM CustomerData

SELECT *
FROM TransactionData

SELECT *
FROM SocialMedia

INSERT INTO CustomerData (CustomerID,CustomerName,Region,Age,Income,CustomerType)
SELECT DISTINCT CustomerID,CustomerName,Region,Age,Income,CustomerType
FROM Afritech


INSERT INTO TransactionData(CustomerID,TransactionYear,TransactionDate,ProductPurchased,PurchaseAmount,ProductRecalled)
SELECT CustomerID,TransactionYear,TransactionDate,ProductPurchased,PurchaseAmount,ProductRecalled
FROM Afritech


INSERT INTO SocialMedia(CustomerID,Competitor_x,InteractionDate,Platform,PostType,EngagementLikes,EngagementShares,EngagementComments,
UserFollowers,InfluencerScore,BrandMention,CompetitorMention,Sentiment,CrisisEventTime,FirstResponseTime,ResolutionStatus,NPSResponse) 
SELECT CustomerID,Competitor_x,InteractionDate,Platform,PostType,EngagementLikes,EngagementShares,EngagementComments,
UserFollowers,InfluencerScore,BrandMention,CompetitorMention,Sentiment,CrisisEventTime,FirstResponseTime,ResolutionStatus,NPSResponse
FROM Afritech

