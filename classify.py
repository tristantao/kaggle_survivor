import csv as csv
import numpy as np
import scipy
from sklearn.svm import SVC
from sklearn import neighbors
from sklearn import cross_validation

#Open up the csv file in to a Python object
csv_file_object = csv.reader(open('train.csv', 'rb'))
header = csv_file_object.next()
data=[]
for row in csv_file_object:
    data.append(row)

data = np.array(data)

predict_csv_file_object = csv.reader(open('test.csv', 'rb'))
predict_header = predict_csv_file_object.next()
predict_data=[]
for row in predict_csv_file_object:
    predict_data.append(row)

predict_data = np.array(predict_data)


def replace_gender(arg):
    if arg.lower().strip() == "male":
        return 0
    elif arg.lower().strip() == "female":
        return 1

def check_age(arg):
    try:
        float(arg)
    except ValueError:
        return 0
    return float(arg)

replace_gender = np.vectorize(replace_gender) #now we can apply it to a row
check_age = np.vectorize(check_age) 

train_y = data[:, [1]]

def curate_data(data, train=True):
    #TODO try: change age return
    #normalize all
    #remove columns approach
    if train:
        data = scipy.delete(data, 1, 1)  # delete survial row, if training data
    else: #do nothing
        pass
    data = scipy.delete(data, 2, 1)  # delete name row
    data = scipy.delete(data, 6, 1)  # delete ticket (ex"PC 17599") row
    data = scipy.delete(data, 7, 1)  # delete cabin (ex"C85") row
    data = scipy.delete(data, 7, 1)  # delete other (ex"C") row
    data = scipy.delete(data, 0, 1)  # delete passenger ID row
    data[:,1] = replace_gender(data[:,1]) #apply gender replacement
    data[:,2] = check_age(data[:,2]) #apply age replacement
    data[:,3] = check_age(data[:,3]) #apply number replacement
    data[:,4] = check_age(data[:,4]) #apply number replacement
    data[:,5] = check_age(data[:,5]) #apply number replacement
    return data
#y = x.astype(np.float)

train_x = curate_data(data)

X_train, X_test, y_train, y_test = cross_validation.train_test_split(
    train_x, train_y, test_size=0.2, random_state=0)

predict_x =  curate_data(predict_data, train=False)
#clf = SVC(C=1.0, kernel='rbf', degree=3, gamma=0.0, coef0=0.0, shrinking=True, probability=False, tol=0.001, cache_size=200, class_weight=None, verbose=False, max_iter=-1, random_state=None)
t

for i in xrange(1, 100):
    #clf = neighbors.KNeighborsClassifier(i, weights='distance')
    #clf = SVC(kernel="rbf", C=0.001 + float(i)/100,) #C = 1.07
    clf = SVC(kernel="rbf", C=1.07, gamma=0.0001 + float(i)/100) #C = 1.07, gammaa .1801
    clf.fit(X_train, y_train)
    clf.score(X_test, y_test)

clf.score(train_x, train_y)

clf = neighbors.KNeighborsClassifier(17)
clf.fit(train_x, train_y)
#clf.fit(train_x, train_y)
#clf.score(train_x, train_y)

result_y = clf.predict(predict_x)
result_y = result_y.astype(np.int)
np.savetxt("prediction.csv", result_y, delimiter=",", fmt ="%s")

#temp = np.apply_along_axis(replace_gender, axis=1, arr=data )
