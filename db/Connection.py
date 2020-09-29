import pymongo

# DATA CONNECTION
CLIENT = "mongodb://localhost:27017/"
DATABASE = "dbmovies"


class Connection:

    @staticmethod
    def db():
        conn_client = pymongo.MongoClient(CLIENT)
        db = conn_client[DATABASE]
        return db


