//
//  AppError.swift
//  Arista
//
//  Created by Benjamin LEFRANCOIS on 27/06/2024.
//

import Foundation

enum AppError: Error {

    case userIsNil
    case fetchUser
    case fetchSleeps
    case fetchUserExercises
    case deleteUserExercise
    case fetchExerciseTypes
    case addUserExercise
    case addUserExerciseCauseExerciseIsNil
    case addUserExerciseCauseDuration

    private var messagePrefix: String {
        return "Oups ! Une erreur s'est produite"
    }

    var message: String {
        switch self {
        case .userIsNil:
            print("AppError: userIsNil")
            return "\(messagePrefix), utilisateur inexistant."

        case .fetchUser:
            print("AppError: fetchUser")
            return "\(messagePrefix) lors de la récupération de votre compte."

        case .fetchSleeps:
            print("AppError: fetchSleeps")
            return "\(messagePrefix) lors de la récupération de vos sessions de sommeil."

        case .fetchUserExercises:
            print("AppError: fetchUserExercises")
            return "\(messagePrefix) lors de la récupération de vos exercices."

        case .deleteUserExercise:
            print("AppError: deleteUserExercise")
            return "\(messagePrefix) lors de la suppression de l'exercice, veuillez réessayer."

        case .fetchExerciseTypes:
            print("AppError: fetchExerciseTypes")
            return "\(messagePrefix) lors de la récupération de la liste des exercices."

        case .addUserExercise:
            print("AppError: addUserExercise")
            return "\(messagePrefix) lors de l'ajout de votre exercice, veuillez réessayer."

        case .addUserExerciseCauseExerciseIsNil:
            print("AppError: addUserExerciseCauseExerciseIsNil")
            return "Oups ! Veuillez renseigner un exercice."

        case .addUserExerciseCauseDuration:
            print("AppError: addUserExerciseCauseDuration")
            return "Oups ! Veuillez renseigner une durée."
        }
    }
}
