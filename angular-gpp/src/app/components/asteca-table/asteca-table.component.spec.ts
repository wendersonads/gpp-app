import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AstecaTableComponent } from './asteca-table.component';

describe('AstecaTableComponent', () => {
  let component: AstecaTableComponent;
  let fixture: ComponentFixture<AstecaTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AstecaTableComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(AstecaTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
