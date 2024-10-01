import 'package:walking_app/utils/app_utils.dart';

class CustomKalmanFilter3D {
  // Kalman Filter parameters
  List<double> x; // State estimate vector [gx, gy, gz] for gyroscope data
  List<List<double>> P; // Error covariance matrix
  List<List<double>> F; // State transition matrix
  List<List<double>> H; // Measurement matrix
  List<List<double>> Q; // Process noise covariance matrix
  List<List<double>> R; // Measurement noise covariance matrix

  // Constructor to initialize the filter
  CustomKalmanFilter3D({
    required List<double> initialState, // Initial state vector [gx, gy, gz]
    required List<List<double>> initialP, // Initial error covariance matrix
    required List<List<double>> processNoise, // Process noise covariance matrix
    required List<List<double>>
        measurementNoise, // Measurement noise covariance matrix
  })  : x = initialState,
        P = initialP,
        F = [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1],
        ], // State transition matrix for constant rotation
        H = [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 1],
        ], // Measurement matrix, measured state corresponds to gyroscope data
        Q = processNoise,
        R = measurementNoise;

  // Perform the prediction step
  void predict() {
    // Predict the state: x_k|k-1 = F * x_k-1|k-1
    List<List<double>> xMatrix = [
      [x[0]],
      [x[1]],
      [x[2]]
    ];
    List<List<double>> xPred = AppUtils.multiplyMatrix(F, xMatrix);
    x[0] = xPred[0][0];
    x[1] = xPred[1][0];
    x[2] = xPred[2][0];

    // Predict the error covariance: P_k|k-1 = F * P_k-1|k-1 * F^T + Q
    P = AppUtils.addMatrix(
        AppUtils.multiplyMatrix(
            AppUtils.multiplyMatrix(F, P), AppUtils.transposeMatrix(F)),
        Q);
  }

  // Perform the update step
  void update(List<double> z) {
    // Kalman gain: K = P_k|k-1 * H^T * (H * P_k|k-1 * H^T + R)^-1
    List<List<double>> Ht = AppUtils.transposeMatrix(H);
    List<List<double>> S = AppUtils.addMatrix(
        AppUtils.multiplyMatrix(AppUtils.multiplyMatrix(H, P), Ht), R);
    List<List<double>> SInv = AppUtils.invert3x3Matrix(S);
    List<List<double>> K =
        AppUtils.multiplyMatrix(AppUtils.multiplyMatrix(P, Ht), SInv);

    // Update the state: x_k|k = x_k|k-1 + K * (z_k - H * x_k|k-1)
    List<List<double>> zMatrix = [
      [z[0]],
      [z[1]],
      [z[2]]
    ];
    List<List<double>> xMatrix = [
      [x[0]],
      [x[1]],
      [x[2]]
    ];
    List<List<double>> y =
        AppUtils.subtractMatrix(zMatrix, AppUtils.multiplyMatrix(H, xMatrix));
    List<List<double>> K_y = AppUtils.multiplyMatrix(K, y);
    x[0] += K_y[0][0];
    x[1] += K_y[1][0];
    x[2] += K_y[2][0];

    // Update the error covariance: P_k|k = (I - K * H) * P_k|k-1
    List<List<double>> I = [
      [1, 0, 0],
      [0, 1, 0],
      [0, 0, 1],
    ];
    List<List<double>> KH = AppUtils.multiplyMatrix(K, H);
    List<List<double>> I_KH = AppUtils.subtractMatrix(I, KH);
    P = AppUtils.multiplyMatrix(I_KH, P);
  }

  // Get the current state estimate
  List<double> get getState => x;
}
