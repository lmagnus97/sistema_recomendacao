import math


class Result:

    def __init__(self, rmse, mae, mse, count):
        self.rmse = rmse
        self.mae = mae
        self.mse = mse
        self.count = count

    def increment(self, data):
        if data is not None and data.count > 0:
            self.rmse += math.sqrt(data.rmse / data.count)
            self.mae += (data.mae / data.count)
            self.mse += (data.mse / data.count)
            self.count += 1

