class Result:

  def __init__(self, rmse, mae, mse):
    self.rmse = rmse
    self.mae = mae
    self.mse = mse

p1 = Result("John", 36)

print(p1.name)
print(p1.age)