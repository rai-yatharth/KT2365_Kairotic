import '../models/employee_input.dart';
import '../models/employee_record.dart';

/// Seeded mock data for demo. Replace with Firestore fetch if needed.
List<EmployeeRecord> getMockEmployees() {
  return [
    EmployeeRecord(
      id: '1',
      gender: 'Male',
      merit: EmployeeInput(
        projectsOwned: 5,
        projectsCompleted: 4,
        avgTeamSize: 3,
        projectsPerQuarter: [1, 1, 2],
        selfInitiatedProjects: 1,
        impactBucket: 'My team',
      ),
      promoted: true,
    ),
    EmployeeRecord(
      id: '2',
      gender: 'Male',
      merit: EmployeeInput(
        projectsOwned: 4,
        projectsCompleted: 3,
        avgTeamSize: 5,
        projectsPerQuarter: [1, 1, 1],
        selfInitiatedProjects: 0,
        impactBucket: 'Multiple teams',
      ),
      promoted: true,
    ),
    EmployeeRecord(
      id: '3',
      gender: 'Male',
      merit: EmployeeInput(
        projectsOwned: 3,
        projectsCompleted: 2,
        avgTeamSize: 2,
        projectsPerQuarter: [1, 1, 0],
        selfInitiatedProjects: 0,
        impactBucket: 'Only me',
      ),
      promoted: false,
    ),
    EmployeeRecord(
      id: '4',
      gender: 'Female',
      merit: EmployeeInput(
        projectsOwned: 5,
        projectsCompleted: 5,
        avgTeamSize: 4,
        projectsPerQuarter: [2, 1, 2],
        selfInitiatedProjects: 2,
        impactBucket: 'Multiple teams',
      ),
      promoted: false,
    ),
    EmployeeRecord(
      id: '5',
      gender: 'Female',
      merit: EmployeeInput(
        projectsOwned: 4,
        projectsCompleted: 4,
        avgTeamSize: 3,
        projectsPerQuarter: [1, 2, 1],
        selfInitiatedProjects: 1,
        impactBucket: 'My team',
      ),
      promoted: false,
    ),
    EmployeeRecord(
      id: '6',
      gender: 'Female',
      merit: EmployeeInput(
        projectsOwned: 3,
        projectsCompleted: 3,
        avgTeamSize: 2,
        projectsPerQuarter: [1, 1, 1],
        selfInitiatedProjects: 0,
        impactBucket: 'Only me',
      ),
      promoted: true,
    ),
    EmployeeRecord(
      id: '7',
      gender: 'Male',
      merit: EmployeeInput(
        projectsOwned: 2,
        projectsCompleted: 1,
        avgTeamSize: 1,
        projectsPerQuarter: [0, 1, 0],
        selfInitiatedProjects: 0,
        impactBucket: 'Only me',
      ),
      promoted: false,
    ),
    EmployeeRecord(
      id: '8',
      gender: 'Female',
      merit: EmployeeInput(
        projectsOwned: 6,
        projectsCompleted: 5,
        avgTeamSize: 6,
        projectsPerQuarter: [2, 2, 1],
        selfInitiatedProjects: 1,
        impactBucket: 'External users',
      ),
      promoted: false,
    ),
    EmployeeRecord(
      id: '9',
      gender: 'Male',
      merit: EmployeeInput(
        projectsOwned: 5,
        projectsCompleted: 4,
        avgTeamSize: 4,
        projectsPerQuarter: [1, 2, 1],
        selfInitiatedProjects: 1,
        impactBucket: 'My team',
      ),
      promoted: true,
    ),
    EmployeeRecord(
      id: '10',
      gender: 'Female',
      merit: EmployeeInput(
        projectsOwned: 4,
        projectsCompleted: 3,
        avgTeamSize: 3,
        projectsPerQuarter: [1, 1, 1],
        selfInitiatedProjects: 0,
        impactBucket: 'My team',
      ),
      promoted: false,
    ),
  ];
}
