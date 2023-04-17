from unittest import TestCase, mock
from io import StringIO

from authentication import (get_git_root, authenticate)
from get_group_ids import get_group_ids
from get_project_ids import get_project_ids
from refresh_policies import get_iam_policies

import git
import json
import os


class AuthenticationTests(TestCase):
    def test_get_git_root(self):
        self.assertEqual(get_git_root(), git.Repo(
            '.', search_parent_directories=True).git.rev_parse("--show-toplevel"))

    def test_authenticate(self):
        self.assertEqual(len(authenticate()), 2624)


class GroupIdsTests(TestCase):

    def setUp(self):
        self.stdout_mock = StringIO()

    def tearDown(self):
        del self.stdout_mock

    def test_get_group_ids(self):
        with mock.patch("sys.stdout", self.stdout_mock):
            get_group_ids()

        # Load the captured JSON data
        captured_json_data = json.loads(self.stdout_mock.getvalue())

        # Check that the captured JSON data is a dictionary
        self.assertIsInstance(captured_json_data, dict)

        # Check that all the keys and values in the dictionary are strings
        for key, value in captured_json_data.items():
            self.assertIsInstance(key, str)
            self.assertIsInstance(value, str)


class ProjectIdsTests(TestCase):

    def setUp(self):
        self.stdout_mock = StringIO()

    def tearDown(self):
        del self.stdout_mock

    def test_get_project_ids_outputs_valid_json(self):
        with mock.patch("sys.stdout", self.stdout_mock):
            get_project_ids()

        # Load the captured JSON data
        captured_json_data = json.loads(self.stdout_mock.getvalue())

        # Check that the captured JSON data is a dictionary
        self.assertIsInstance(captured_json_data, dict)

        # Check that all the keys and values in the dictionary are strings
        for key, value in captured_json_data.items():
            self.assertIsInstance(key, str)
            self.assertIsInstance(value, str)


class PoliciesTests(TestCase):

    @classmethod
    def setUpClass(cls):
        get_iam_policies()

    @classmethod
    def tearDownClass(cls):
        git_repo = get_git_root()
        file_path = os.path.join(os.getcwd(), f"{git_repo}/policies.json")
        os.remove(file_path)

    def test_policies_json_file_exists(self):
        git_repo = get_git_root()
        file_path = os.path.join(os.getcwd(), f"{git_repo}/policies.json")
        self.assertTrue(os.path.exists(file_path))

    def test_policies_json_contents_are_valid(self):
        git_repo = get_git_root()
        file_path = os.path.join(os.getcwd(), f"{git_repo}/policies.json")

        # Load the contents of the file
        with open(file_path, 'r') as f:
            contents = json.load(f)

        # Check the datatype
        self.assertIsInstance(contents, dict)

        # Check the datatypes of keys and values
        for key, value in contents.items():
            self.assertIsInstance(key, str)
            self.assertIsInstance(value, list)

            for element in value:
                for key, value in element.items():
                    self.assertIsInstance(key, str)
                    self.assertIsInstance(value, str)
