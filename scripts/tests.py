from unittest import TestCase

from authentication import get_git_root, authenticate
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
