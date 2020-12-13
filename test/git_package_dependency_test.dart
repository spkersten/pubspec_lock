/*
 * MIT License
 *
 * Copyright (c) 2019 Alexei Sintotski
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

import 'package:pubspec_lock/pubspec_lock.dart';
import 'package:test/test.dart';

void main() {
  group('$PubspecLock.loadFromYamlString', () {
    group('given pubspec.lock with single git dependency', () {
      final pubspecLock = pubspecWithGitDependency.loadPubspecLockFromYaml();
      test('it produces exactly one dependency object', () {
        expect(pubspecLock.packages.length, 1);
      });
      test('it produces PackageDependency with correct package name', () {
        expect(pubspecLock.packages.first.package(), package);
      });
      test('it produces PackageDependency with correct version', () {
        expect(pubspecLock.packages.first.version(), version);
      });
      test('it produces PackageDependency of correct type', () {
        expect(pubspecLock.packages.first.type(), DependencyType.direct);
      });
      test('it produces GitPackageDependency object', () {
        expect(isGitDependency(pubspecLock.packages.first), isTrue);
      });
      test('it produces GitPackageDependency object with correct data', () {
        expect(
          gitPackageDependency(pubspecLock.packages.first),
          expectedPackageDependency,
        );
      });
    });
  });

  group('$PubspecLock.toYaml', () {
    group('given pubspec.lock with single git dependency', () {
      final pubspecLock = pubspecWithGitDependency.loadPubspecLockFromYaml();
      final yamlOutput = pubspecLock.toYamlString();
      test('it produces equivalent output', () {
        expect(yamlOutput, pubspecWithGitDependency);
      });
    });
  });
}

const package = 'flutter_html';
const version = '0.9.6';
const ref = 'HEAD';
const url = 'https://git.pattle.im/forks/flutter_html.git';
const path = '.';
const resolvedRef = '5a9523745e89755eccb32fb8123d5723593db02a';

const pubspecWithGitDependency = '''
# Generated by pub
# See https://dart.dev/tools/pub/glossary#lockfile
packages:
  $package:
    dependency: "direct main"
    description:
      path: "$path"
      ref: $ref
      resolved-ref: "5a9523745e89755eccb32fb8123d5723593db02a"
      url: "$url"
    source: git
    version: "$version"
''';

const expectedPackageDependency = GitPackageDependency(
  package: package,
  version: version,
  ref: ref,
  url: url,
  path: path,
  resolvedRef: resolvedRef,
  type: DependencyType.direct,
);

bool isGitDependency(PackageDependency dependency) => dependency.iswitcho(
      git: (d) => true,
      otherwise: () => false,
    );

GitPackageDependency gitPackageDependency(PackageDependency dependency) =>
    dependency.iswitcho(
      git: (d) => d,
      otherwise: () => null,
    );
