# The Rick and Morty API Request
<br>
<p align="center">
<img src ='https://m.media-amazon.com/images/M/MV5BZjRjOTFkOTktZWUzMi00YzMyLThkMmYtMjEwNmQyNzliYTNmXkEyXkFqcGdeQXVyNzQ1ODk3MTQ@._V1_QL75_UX500_CR0,234,500,281_.jpg'>
</p>
- The Rick and Morty API is a REST(ish) and GraphQL API based on the television show Rick and Morty. You will have access to about hundreds of characters, images, locations and episodes. The Rick and Morty API is filled with canonical information as seen on the TV show.

## Tools🛠️:
- Google Colab (Python)
- Python Library : `pandas`, `requests`, `time`
- API url : `https://rickandmortyapi.com/api/character/`

## Operations⌛:
- `Data manipulation`
- `Data Visualization`

# Code review🔎:

## Step 1 : Import Data with API Requests
- import library and list for contain data from API
- use for loop to get data from API and include "time.sleep()" to delay GET method
- when you get data from API assign to list target

## Step 2 : Create Dataframe with list using "pd.DataFrame"   
- use "pd.DataFrame" to create dataframe with list from API
- save dataframe to csv file for easy to use