import requests
from dao.MoviesDao import MoviesDao

API_ENDPOINT = "https://api.themoviedb.org/3/movie/"
API_KEY = "f3bd69106606029a48d8cb74279ed8b3"

data = {'api_key': API_KEY}

for link in MoviesDao.get_movies_links():
    response = requests.get(url=API_ENDPOINT + link['tmdbId'], params=data)
    print(response.text)
