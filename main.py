import flask

from dao.MoviesDao import MoviesDao
from dao.MyListDAO import MyListDAO
from dao.RatingDAO import RatingDAO
from dao.UserDAO import UserDAO
from logic.Recommender import Recommender
from flask import request, jsonify

app = flask.Flask(__name__)
app.config["DEBUG"] = False


@app.route('/<id>', methods=['GET'])
def home(id):
    return jsonify(Recommender.init(id))


@app.route('/user', methods=['POST'])
def api_add_user():
    id = UserDAO.add(request.json)

    return jsonify({"id": str(id)})


@app.route('/rating', methods=['POST'])
def api_add_rating():
    id = RatingDAO.add(request.json)

    return jsonify({"id": str(id)})


@app.route('/ratings/<id>', methods=['GET'])
def api_ratings_user(id):
    return jsonify(RatingDAO.get_user_ratings_api(id))


@app.route('/rating/<user_id>/<movie_id>', methods=['GET'])
def api_rating(user_id, movie_id):
    result = RatingDAO.get(user_id, movie_id)

    if result is not None:
        return jsonify(result)
    return {"status": "Inexistente"}, 500


@app.route('/mylist', methods=['POST'])
def api_add_mylist():
    id = MyListDAO.add(request.json)

    return jsonify({"id": str(id)})


@app.route('/mylist/<id>', methods=['DELETE'])
def api_delete_mylist(id):
    MyListDAO.delete(id)

    return jsonify({"status": "ok"})


@app.route('/mylist/<id>', methods=['GET'])
def api_get_mylist(id):
    return jsonify(MyListDAO.get_all(id))


@app.route('/movie/<tmdb>', methods=['GET'])
def api_get_movie_tmdb(tmdb):
    link = MoviesDao.get_tmdb_exist(tmdb)
    if MoviesDao.get_tmdb_exist(tmdb) is None:
        return {"status": "Não encontrado"}, 500
    else:
        return {"movieId": link['movieId']}


@app.route('/conn', methods=['GET'])
def api_test_connection():
    return {"status": "OK"}


app.run(threaded=True, host='0.0.0.0')
