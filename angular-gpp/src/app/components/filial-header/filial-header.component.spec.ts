import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FilialHeaderComponent } from './filial-header.component';

describe('FilialHeaderComponent', () => {
  let component: FilialHeaderComponent;
  let fixture: ComponentFixture<FilialHeaderComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FilialHeaderComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FilialHeaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
