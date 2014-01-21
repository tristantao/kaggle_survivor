import csv as csv
import numpy as np
import scipy
from sklearn.svm import SVC
from sklearn import neighbors
from sklearn import cross_validation
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier

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

def number_replacement(arg, rep_target):
    try:
        float(arg)
    except ValueError:
        return rep_target
    return float(arg)

def normalize(arg, min, max):
    try:
        return (float(arg)-min)/(max-min)
    except ValueError as vE:
        return 0

normalize = np.vectorize(normalize)
replace_gender = np.vectorize(replace_gender) #now we can apply it to a row
number_replacement = np.vectorize(number_replacement)

train_y = data[:, [1]]


def curate_data(data, train=True):
    #TODO try: change age return
    #normalize all
    #remove columns approach
    min_max = []
    for col in data.T:
        min_max.append((min(col), max(col)))
    print min_max
    data[:,0] = number_replacement(data[:,0], 446) #apply number replacement
    data[:,1] = number_replacement(data[:,1], .3838) #apply number replacement
    data[:,2] = number_replacement(data[:,2], 2.3) #apply number replacement
    data[:,5] = number_replacement(data[:,5], 29.7) #apply number replacement
    data[:,6] = number_replacement(data[:,6], 0.52) #apply number replacement
    data[:,7] = number_replacement(data[:,7], 0.38) #apply number replacement
    data[:,9] = number_replacement(data[:,9], 32.204) #apply number replacement
    print data
    if train:
        data = scipy.delete(data, 1, 1)  # delete survial row, if training data
    else: #do nothing
        pass
    data = scipy.delete(data, 2, 1)  # delete name row
    data = scipy.delete(data, 6, 1)  # delete ticket (ex"PC 17599") row
    data = scipy.delete(data, 7, 1)  # delete cabin (ex"C85") row
    data = scipy.delete(data, 7, 1)  # delete other (ex"C") row
    data = scipy.delete(data, 0, 1)  # delete passenger ID row
    data = scipy.delete(data, 3, 1)  #delete parch
    #data = scipy.delete(data, 4, 1)
    #data = scipy.delete(data, 3, 1)
    #data = scipy.delete(data, 2, 1)
    print "BEFORE NORMALIZATION"
    print data[1:10]
    data[:,0] = normalize(data[:,0], 0, 3) #class
    data[:,1] = replace_gender(data[:,1]) #apply gender replacement
    data[:,2] = normalize(data[:,2], 0.5, 80) #age
    data[:,3] = normalize(data[:,3], 0, 6) #parch
    data[:,4] = normalize(data[:,4], 0, 512.3) #price
    return data

train_x = curate_data(data)
print train_x[1:5]
X_train, X_test, y_train, y_test = cross_validation.train_test_split(
    train_x, train_y, test_size=0.5, random_state=0)

predict_x =  curate_data(predict_data, train=False)
#clf = SVC(C=1.0, kernel='rbf', degree=3, gamma=0.0, coef0=0.0, shrinking=True, probability=False, tol=0.001, cache_size=200, class_weight=None, verbose=False, max_iter=-1, random_state=None)

a = np.array([a[0] for a in y_train])

for i in xrange(1, 100):
    #clf = neighbors.KNeighborsClassifier(i, weights='distance')
    #clf = SVC(kernel="rbf", C=0.001 + float(i)/100,) #C = 1.07
    #clf = SVC(kernel="rbf", C=0.001 + float(i)/100, gamma=float(i)/1000 + 0.0001 + float(i)/10000 + float(i)/100) #C = 1.07, gammaa .1801
    #clf = DecisionTreeClassifier(max_depth=None)
    clf =  RandomForestClassifier(max_depth=None, n_estimators=10, max_features=None, verbose=False)
    #clf =  AdaBoostClassifier(base_estimator=DecisionTreeClassifier(compute_importances=None, criterion='gini', max_depth=i, max_features=None, min_density=None))xs
    clf.fit(X_train, a)
    print str(clf.score(X_test, y_test)) + " " + str(i)

clf.score(train_x, train_y)

#BEST CLF
#clf = neighbors.KNeighborsClassifier(87, weights='distance')
#clf = SVC(kernel="rbf", C=1.07, gamma=0.1501) #C = 1.07, gammaa .1801
#clf = GaussianNB() #Doesnt work
#clf = DecisionTreeClassifier(max_depth=7) #73.3
clf =  RandomForestClassifier(max_depth=None, n_estimators=10, max_features=None)
#clf =  AdaBoostClassifier(base_estimator=DecisionTreeClassifier(compute_importances=None, criterion='gini', max_depth=i, max_features=None, min_density=None))
a = np.array([a[0] for a in y_train])

clf.fit(train_x, train_y)
#clf.fit(X_train, a)
print clf.score(train_x, train_y)

result_y = clf.predict(predict_x)
result_y = result_y.astype(np.int)
np.savetxt("new_RF_prediction.csv", result_y, delimiter=",", fmt ="%s")

#temp = np.apply_along_axis(replace_gender, axis=1, arr=data )
