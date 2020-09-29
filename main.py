from logic.Brain import Brain
from dao.MoviesDao import MoviesDao

print(Brain.recommender_user(MoviesDao.load_data(), "1"))
